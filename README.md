# kaarbs
kojiros automated arch ricing bash script

This script is intended to be a quick/lazy way of auto-installing all the packages I normally would but with the option to pick and choose what you want to install. This is mainly for my personal use, however others could use it (at their own risk). Because of my lack of technical knowledge it does still require a *slight* amount of tinkering afterwards, but this should do for now.

# Instructions:
1. Clone the repo + move the script to your home folder:
```
git clone https://github.com/basedghost/kaarbs/ && mv kaarbs/kaarbs_*.sh kaarbs.sh
```
2. Make the script executable:
```
chmod +x kaarbs.sh
```
3. Run the script:
```
./kaarbs.sh
```
(Recommended) If you would like to view the contents of the script before executing it:
```
cat kaarbs.sh
```

This script has been tested on a fresh [Arch Linux](https://archlinux.org/download/) install in QEMU-KVM and on a Thinkpad T500 (using the archinstall script + multilib repo + networkmanager + pipewire)

This script pulls dotfiles from my [personal repository](https://github.com/basedghost/dotfiles/).
There is a [complete list of packages](PACKAGES.md) that this script gives you the choice of installing, if you'd like to check before running it.

**A screenshot of the test:**
![screenshot](https://user-images.githubusercontent.com/111021033/200684659-681723c1-ddcb-43f0-a3fd-d295df2ae991.png)

There is a [systemd-free fork](https://github.com/basedghost/kaarbs-openrc) of this script if you are using the OpenRC init system (or would prefer it).

## post-script tweaks

Here's a couple of things you might want to do after using kaarbs:
- If you'd like to use the [custom sudo lecture](https://github.com/basedghost/dotfiles/blob/main/lecture), use ```sudo visudo``` and add these two lines: 
```
"Defaults lecture=always"
"Defaults lecture_file=~/lecture"
```
- If you'd like to use animated cursors, use the program lxappearance to choose between them.
- If you installed virt-manager, you must edit your `/etc/libvirt/libvirtd.conf` and uncomment `unix_sock_group` `unix_sock_ro_perms` and `unix_sock_rw_perms`.
Then run ```sudo usermod -aG libvirt $(whoami)``` and reboot.

## Issues
If any issues with certain packages arise, they will be noted here.
- Picom has recently been leaking both host and gpu memory. It has been temporarily disabled from the script.
