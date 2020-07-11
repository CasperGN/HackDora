# Init variables

BASHRC="/home/$(logname)/.bashrc"

# Repo fetching
echo "[+] Updating OS packages..." 
sudo dnf update -y &>/dev/null
sudo dnf install -y make gcc-c++ mingw64-filesystem mingw32-gcc mingw32-gcc-c++ mingw32-gcc-objc mingw32-gcc-objc++ mingw32-gcc-gfortran mingw64-gcc mingw64-gcc-c++ mingw64-gcc-objc mingw64-gcc-objc++ mingw64-gcc-gfortran java-latest-openjdk-devel &>/dev/null

echo "[+] Adding forensics.cert as rpm repo"
wget https://forensics.cert.org/cert-forensics-tools-release-32.rpm &>/dev/null
sudo dnf install cert-forensics-tools-release-32.rpm &>/dev/null

echo "[+] Installing Python, Ruby, Go and Git..." 
sudo dnf install -y python3 python3-pip rubygems ruby-devel git golang &>/dev/null

# Add Neo4J repo (see https://neo4j.com/docs/operations-manual/current/installation/linux/rpm/) and install
echo "[+] Installing Neo4j..." 
rpm --import https://debian.neo4j.com/neotechnology.gpg.key &>/dev/null
cat <<EOF >  /etc/yum.repos.d/neo4j.repo 
[neo4j]
name=Neo4j RPM Repository
baseurl=https://yum.neo4j.com/stable
enabled=1
gpgcheck=1
EOF

sudo dnf install -y https://dist.neo4j.org/neo4j-java11-adapter.noarch.rpm --skip-broken &>/dev/null
sudo dnf install -y java-11-openjdk &>/dev/null
sudo dnf install -y neo4j-4.0.5 &>/dev/null

echo "[+] Installing hax0r-tools from repo..." 
sudo dnf install -y nmap wireshark ftp fcrackzip &>/dev/null

# Pip packages
echo "[+] Installing hax0r-tools from Pip..." 
echo -e "\t- Installing Impacket..."
python3 -m pip install impacket &>/dev/null

echo -e "\t- Installing AclPwn..."
python3 -m pip install aclpwn &>/dev/null

# Git 
echo "[+] Installing hax0r-tools from Git..." 
echo -e "\t- Installing smbmap..."
if [ ! -d /usr/share/smbmap ]; then
	sudo mkdir /usr/share/smbmap
fi

git clone https://github.com/ShawnDEvans/smbmap.git &>/dev/null && \
	sudo cp -r smbmap/psutils/ smbmap/smbmap.py /usr/share/smbmap &>/dev/null && \
	
echo -e "\t- Installing Wordlists..."
git clone https://github.com/praetorian-code/Hob0Rules.git &>/dev/null && \
	sudo cp -r Hob0Rules/wordlists /usr/share &>/dev/null && \
	sudo gunzip -f /usr/share/wordlists/rockyou.txt.gz /usr/share/wordlists/rockyou.txt &>/dev/null && \
	sudo gunzip -f /usr/share/wordlists/english.txt.gz /usr/share/wordlists/english.txt &>/dev/null && \
	sudo rm /usr/share/wordlists/rockyou.txt.gz &>/dev/null && \
	sudo rm /usr/share/wordlists/english.txt.gz &>/dev/null

if [ -d /usr/share/wordlists/SecLists ]; then
	sudo rm -rf /usr/share/wordlists/SecLists
fi
git clone https://github.com/danielmiessler/SecLists.git &>/dev/null && \
	sudo mv SecLists /usr/share/wordlists &>/dev/null
	
echo -e "\t- Installing ActiveDirectoryEnum..."
if [ -d /usr/share/ActiveDirectoryEnumeration ]; then
	rm -rf /usr/share/ActiveDirectoryEnumeration &>/dev/null
fi
git clone https://github.com/CasperGN/ActiveDirectoryEnumeration.git &>/dev/null && \
	python3 -m pip install ActiveDirectoryEnumeration/. &>/dev/null && \
	sudo mv ActiveDirectoryEnumeration /usr/share &>/dev/null
	
echo -e "\t- Installing Bloodhound..."
wget https://github.com/BloodHoundAD/BloodHound/releases/download/3.0.4/BloodHound-linux-x64.zip &>/dev/null
unzip BloodHound-linux-x64.zip &>/dev/null
mv BloodHound-linux-x64 bloodhound && sudo mv bloodhound /usr/share &>/dev/null
rm BloodHound-linux-x64.zip &>/dev/null

echo -e "\t- Installing SQLMap..."
if [ -d /usr/share/sqlmap ]; then
	rm -rf /usr/share/sqlmap &>/dev/null
fi
git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git &>/dev/null && \
	sudo mv sqlmap /usr/share/ &>/dev/null

# Ruby gems
echo "[+] Installing hax0r-tools from Ruby-Gems..." 
echo -e "\t- Installing EvilWinRM..."
gem install evil-winrm &>/dev/null

# Go
echo "[+] Installing hax0r-tools from Go..." 
echo -e "\t- Installing Gobuster..."
go get github.com/OJ/gobuster &>/dev/null && \
	sudo mv ~/go/bin/gobuster /usr/share/ &>/dev/null
	
echo -e "\t- Installing GoHead..."
go get https://github.com/CasperGN/GoHead/tree/master/cmd/gohead &>/dev/null && \
	sudo mv ~/go/bin/gohead /usr/share/ &>/dev/null

echo -e "\t- Installing ffuf..."
go get github.com/ffuf/ffuf &>/dev/null && \
	sudo mv ~/go/bin/ffuf /usr/share/ &>/dev/null
	
# Handling env variables	
echo "[+] Updating environment..." 

# PATH update
grep -P "^PATH=\"/usr" $BASHRC &>/dev/null || echo 'PATH="/usr/share:$PATH"' >> $BASHRC

# Aliases
grep -P "^alias\ssmb" $BASHRC &>/dev/null || echo 'alias smbmap="python /usr/share/smbmap/smbmap.py --no-banner"' >> $BASHRC
grep -P "^alias\sbloodhound" $BASHRC &>/dev/null || echo 'alias bloodhound="sudo neo4j start;/usr/share/bloodhound/BloodHound"' >> $BASHRC
grep -P "^alias\sade" $BASHRC &>/dev/null || echo 'alias ade="python /usr/share/ActiveDirectoryEnumeration/activeDirectoryEnum.py"' >> $BASHRC
grep -P "^alias\ssqlmap" $BASHRC &>/dev/null || echo 'alias sqlmap="/usr/share/sqlmap/sqlmap.py"' >> $BASHRC

grep -P "^ROCKYOU" $BASHRC &>/dev/null || echo 'ROCKYOU="/usr/share/wordlists/rockyou.txt"' >> $BASHRC
grep -P "^DIRLIST" $BASHRC &>/dev/null || echo 'DIRLIST="/usr/share/wordlists/SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt"' >> $BASHRC

# Cleanup 
find . -type d -not -name '.git' -exec rm -rf {} + &>/dev/null

echo "[+] Done" 
echo -e "Remember to source environment after changes with:\n. $BASHRC"
