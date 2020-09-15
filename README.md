# HackDora
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2FCasperGN%2FHackDora.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2FCasperGN%2FHackDora?ref=badge_shield)


My Fedora setup for pentesting & Bug hunting

## Install

To avoid annoyance of constant password promts, run as:

```
$ sudo ./setup.sh
```

## Env. variables

To ease calling common items, some environment variables are set as follows:
```
$ tail -5 ~/.bashrc
alias smbmap="python /usr/share/smbmap/smbmap.py --no-banner"
ROCKYOU="/usr/share/wordlists/rockyou.txt"
alias ade="python /usr/share/ActiveDirectoryEnumeration/activeDirectoryEnum.py"
alias bloodhound="sudo neo4j start;/usr/share/bloodhound/BloodHound"
DIRLIST="/usr/share/wordlists/SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt"
```

This enables calling programs as such:
```
$ gobuster dir -w $DIRLIST -u http://10.10.10.185:80
```

## TODO

- [ ] JTR  
- [ ] Hashcat  


## License
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2FCasperGN%2FHackDora.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2FCasperGN%2FHackDora?ref=badge_large)