# kaarbs
kojiros automated arch ricing bash script

This script is intended to be a quick/lazy way of auto-installing all the packages I normally would but with the option to pick and choose what you want to install. This is mainly for my personal use, however others could use it. Because of my lack of technical knowledge it does still require a *slight* amount of tinkering afterwards, but this should do for now.

# Installation:
1. Clone the repo: `git clone https://github.com/basedghost/kaarbs/ && cd kaarbs; mv kaarbs_*.sh ~/kaarbs.sh; cd ..`
2. Make the script executable: `sudo chmod +x kaarbs.sh`
3. To run the script: `./kaarbs.sh`

This script has been tested on a fresh [Arch Linux](https://archlinux.org/download/) install (using the archinstall script + multilib repo enabled + networkmanager + xfce4 DE)

This script pulls dotfiles from my [personal repository](https://github.com/basedghost/dotfiles/).
Here is the [full list of packages](PACKAGES.md) that this script can install.

**A screenshot of the test:**
![screenshot](https://user-images.githubusercontent.com/111021033/184048144-cba87669-57d7-479d-bf45-ed37b7dc4fe2.png)

# post-script tweaks

Here's a couple of things you might want to do after using kaarbs:
- If you'd like to use the custom sudo lecture, use `sudo visudo` to add the lines `"Defaults lecture=always"` and `"Defaults lecture_file=~/lecture"`
- If you'd like to use animated cursors, use the program lxappearance to choose between them.
- If you installed Steam and would like to use Proton-GE, download the latest release [here](https://github.com/GloriousEggroll/proton-ge-custom/releases/latest/) and extract it to this path: `~/.local/share/Steam/compatibilitytools.d/`
- If you installed virt-manager, you must edit your `/etc/libvirt/libvirtd.conf` and uncomment `unix_sock_group` `unix_sock_ro_perms` and `unix_sock_rw_perms`. Then `sudo usermod -aG libvirt $(whoami)` and reboot.
