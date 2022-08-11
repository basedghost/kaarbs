#!/bin/bash

# KAARBS: Kojiros Automated Arch Ricing Bash Script
# ##################################################
# This script is intended to be a quick/lazy way of auto-installing all the packages I normally 
# would but with the option to pick and choose what you want to install. This is mainly for my 
# personal use, however others could, in theory, use it. Because of my lack of technical knowledge
# it does still require a slight amount of tinkering afterwards, but this should do for now.

# LIST OF FUNCTIONS

# Installs dependencies.
install_dep () {
	echo "proceeding to install necessary dependencies.." && sleep 2; 
	sudo pacman -S rsync noto-fonts noto-fonts-cjk noto-fonts-emoji terminus-font aria2 pacman-contrib arandr nvidia-settings ufw neofetch qt5-base qt5-svg qt5-quickcontrols qt5-quickcontrols2 qt5-graphicaleffects zip unzip p7zip ntfs-3g logrotate;
	systemctl enable ufw;
	sudo ufw enable
}

# Confirmation of script initialization.
script_init () {
        while true
        do
        read -p "Welcome to KAARBS (Kojiros Automated Arch Ricing Bash Script). This script will install all of my preferred packages/configs (with a prompt before each one so you can choose which ones you want). Before running this script, please make sure your system is completely up to date. Y to proceed, N to exit, or S to skip ahead if re-running script. [y/n/s]" yn

        case $yn
        in [yY] ) echo installing dependencies...;
                  install_dep && break;;
           [nN] ) echo exiting KAARBS; exit;;
	   [sS] ) echo skipping dependencies...; break;;
              * ) echo invalid response;;
        esac
done
}

# Installs the AUR helper, yay.
install_yay () { 
	git clone https://aur.archlinux.org/yay.git;
	cd yay;
	makepkg -si
}

# The confirmation prompt for yay.
confirm_yay () {
	while true
	do
	read -p "would you like to install the aur helper, yay? [*HIGHLY RECOMMENDED* - REQUIRED FOR MOST PACKAGES IN THIS SCRIPT] [y/n]" yn

	case $yn
	in [yY] ) echo installing yay...;
		  install_yay && break;;
	   [nN] ) echo skipping yay...; break;;
	      * ) echo invalid response;;
	esac
done
}

# Enables flathub repository.
install_flatpak () {
	sudo pacman -S flatpak
}

# Restart the system after enabling flathub repo.
restart_flatpak () {
	systemctl reboot
}

# Confirmation for enabling flathub repo.
confirm_flatpak () {
	while true
        do
        read -p "would you like to enable the flathub repository? [*HIGHLY RECOMMENDED* - REQUIRED FOR MOST PACKAGES IN THIS SCRIPT] [y/n]" yn

        case $yn
        in [yY] ) echo enabling flatpaks...;
                  install_flatpak && break;;
           [nN] ) echo skipping flatpak repo...; break;;
              * ) echo invalid response;;
        esac
done
} 

# Confirmation for rebooting to finish enabling flathub repo.
confirm_restart () {
        while true
        do
        read -p "if you enabled the flathub repo, you must reboot your system to install flatpaks. would you like to reboot now? [run this script again after rebooting to continue] [y/n]" yn

        case $yn
        in [yY] ) echo rebooting...;
                  restart_flatpak;;
           [nN] ) echo skipping reboot...; break;;
              * ) echo invalid response;;
        esac
done
}

# Installs pip, the python package manager.
install_pip () {
    sudo pacman -S python-pip
}

# Confirmation for pip.
confirm_pip () {
    while true
    do
	read -p "would you like to install pip - the python package manager? [only required to install ueberzug] [y/n]" yn

	case $yn
	in [yY] ) echo installing pip;
		  install_pip && break;;
	   [nN] ) echo skipping pip...; break;;
	   * ) echo invalid response;;
	esac
    done
}

# Installs the awesome window manager (and other packages to fill in the gaps)
install_awesomewm () {
	sudo pacman -S awesome nitrogen picom xorg-xwininfo xorg-xprop xscreensaver dmenu polkit-gnome kitty unclutter lxappearance pavucontrol pcmanfm scrot feh imagemagick conky;
	mkdir ~/.config/awesome/;
	git clone --recurse-submodules --remote-submodules --depth 1 -j 2 https://github.com/lcpz/awesome-copycats.git;
	mv -bv awesome-copycats/{*,.[^.]*} ~/.config/awesome;rm -rf awesome-copycats;
	cp ~/.config/awesome/rc.lua.template ~/.config/awesome/rc.lua;
	yay -S lightdm-webkit2-theme-glorious network-manager-applet;
	sudo sed -i 's/^\(#?greeter\)-session\s*=\s*\(.*\)/greeter-session = lightdm-webkit2-greeter #\1/ #\2g' /etc/lightdm/lightdm.conf;
	sudo sed -i 's/^webkit_theme\s*=\s*\(.*\)/webkit_theme = glorious #\1/g' /etc/lightdm/lightdm-webkit2-greeter.conf;
	sudo sed -i 's/^debug_mode\s*=\s*\(.*\)/debug_mode = true #\1/g' /etc/lightdm/lightdm-webkit2-greeter.conf
}

# Confirmation of awesomewm installation.
confirm_awesomewm () {
	while true
	do
	read -p "would you like to install awesomeWM - the dynamic window manager? [y/n]" yn

        case $yn in
	[yY] ) echo installing awesomeWM...;
               install_awesomewm && break;;
        [nN] ) echo skipping awesomeWM...; break;;
           * ) echo invalid response;;
        esac
done
}	

# Copies my configs and themes over

install_configs () {
# Clones the repo of my custom configs/wm theme.
    cd ~/;
    git clone https://github.com/basedghost/dotfiles && cd dotfiles;

# Clones the config directory
    rsync -vrP .config/ ~/.config/

# Clones the icons directory
    rsync -vrP .icons/ ~/.icons/
    
# Clones the /usr/ directory
    rsync -vrP usr/ /usr/
    
# Clones the /etc/ directory
    rsync -vrP etc/ /etc/

# Clones the local directory
    rsync -vrP .local/ ~/.local/
    
# Bashrc
    mv bashrc ~/.bashrc

# Gnu emacs config
    mv emacs ~/.emacs;
    rsync -vrP Pictures/ ~/Pictures/

# Noise gate config file for carla
    mv audio.carxp ~/audio.carxp

# Custom sudo lecture (requires the use of the sudo visudo command to add the lines "Defaults lecture=always" and "Defaults lecture_file=/home/user/lecture")
    mv lecture ~/lecture

# Ffmpeg batch convert script
    mv ffmpeg-batch.sh ~/ffmpeg-batch.sh

# Cleans up the downloaded dotfiles
    cd ~/
    rm -r dotfiles/
    
# Shell color scripts
	yay -S shell-color-scripts;
	colorscript -b 00default.sh;
	colorscript -b alpha;
	colorscript -b arch;
	colorscript -b awk-rgb-test;
	colorscript -b bars;
	colorscript -b blocks1;
	colorscript -b blocks2;
	colorscript -b bloks;
	colorscript -b colorbars;
	colorscript -b colortest;
	colorscript -b colortest-slim;
	colorscript -b colorview;
	colorscript -b colorwheel;
	colorscript -b crowns;
	colorscript -b crunch;
	colorscript -b crunchbang;
	colorscript -b crunchbang-mini;
	colorscript -b darthvader;
	colorscript -b debian;
	colorscript -b dna;
	colorscript -b doom-original;
	colorscript -b doom-outlined;
	colorscript -b faces;
	colorscript -b fade;
	colorscript -b guns;
	colorscript -b hex;
	colorscript -b illumina;
	colorscript -b jangofett;
	colorscript -b kaisen;
	colorscript -b manjaro;
	colorscript -b monster;
	colorscript -b mouseface;
	colorscript -b mouseface2;
	colorscript -b panes;
	colorscript -b print256;
	colorscript -b pukeskull;
	colorscript -b rails;
	colorscript -b rally-x;
	colorscript -b six;
	colorscript -b spectrum;
	colorscript -b square;
	colorscript -b suckless;
	colorscript -b tanks;
	colorscript -b thebat;
	colorscript -b thebat2;
	colorscript -b tiefighter1;
	colorscript -b tiefighter1-no-invo;
	colorscript -b tiefighter1row;
	colorscript -b tiefighter2;
	colorscript -b tux;
	colorscript -b xmonad;
	colorscript -b zwaves
}

# Confirmation to copy my custom configs/theming.
confirm_configs () {
    while true
        do
        read -p "would you like to install kojiros custom configs/themes? [y/n]" yn

        case $yn in
        [yY] ) echo installing kojiros configs/themes...;
               install_configs && break;;
        [nN] ) echo skipping configs...; break;;
           * ) echo invalid response;;
        esac
done
}

# Installs my personal browser of choice, libreWolf.
install_librewolf () {
	yay -S librewolf-bin
}

# Confirmation prompt for libreWolf.
confirm_librewolf () {
	while true
	do
	read -p "would you like to install the librewolf web browser? [requires yay] [y/n]" yn

	case $yn in
	[yY] ) echo installing librewolf...;
               install_librewolf && break;;
        [nN] ) echo skipping librewolf...; break;;
           * ) echo invalid response;;
        esac
done
}

# Installs the brave web browser - if you prefer chromium-based browsers.
install_brave () {
	yay -S brave-bin
}

# Confirmation prompt for Brave.
confirm_brave () {
	while true
	do 
	read -p "would you like to install the brave web browser? [requires yay] [y/n]" yn
 
        case $yn in
	[yY] ) echo installing brave...;
               install_brave && break;;
        [nN] ) echo skipping brave...; break;;
           * ) echo invalid response;;
        esac
done
}

# Installs emacs.
install_emacs () {
	sudo pacman -S emacs;
	systemctl --user enable emacs;
}

# Confirmation prompt for emacs.
confirm_emacs () {
        while true
        do
        read -p "would you like to install gnu emacs? [y/n]" yn

        case $yn in
        [yY] ) echo installing+enabling emacs...;
               install_emacs && break;;
        [nN] ) echo skipping emacs...; break;;
           * ) echo invalid response;;
        esac
done
}

# Installs packages used for multimedia purposes.
install_multimedia () {
	sudo pacman -S carla mpc mpd mpv ncmpcpp qjackctl pavucontrol;
	yay -S abgate.lv2;
	systemctl --user enable mpd;
	systemctl --user start mpd
}

# Confirmation prompt to install multimedia packages.
confirm_multimedia () {
	while true
	do
	read -p "would you like to install frequently used multimedia applications? [requires yay] [y/n]" yn
 
        case $yn in
	[yY] ) echo installing multimedia packages...;
               install_multimedia && break;;
        [nN] ) echo skipping multimedia stuff...; break;;
           * ) echo invalid response;;
        esac
done
}

# Installs ueberzug.
install_ueberzug () {
    sudo pip3 install ueberzug
}

# Confirmation for ueberzug.
confirm_ueberzug () {
    while true
    do
	read -p "would you like to install ueberzug? (used by ncmpcpp to display album art) [requires pip] [y/n]" yn
	case $yn in
	    [yY] ) echo installing ueberzug;
		   install_ueberzug && break;;
	    [nN] ) echo skipping ueberzug...; break;;
	    * ) echo invalid response;;
	esac
    done
}

# Installs ncmpcpp-ueberzug.
install_ncmpcpp-ueberzug () {
    cd ~/.config/ncmpcpp;
    git clone https://github.com/alnj/ncmpcpp-ueberzug.git;
    cd ncmpcpp-ueberzug/;
    chmod +x ncmpcpp-ueberzug ncmpcpp_cover_art.sh;
    ln -s ~/.config/ncmpcpp/ncmpcpp-ueberzug/ncmpcpp-ueberzug ~/.local/bin/
}

# Confirmation for ncmpcpp-ueberzug
confirm_ncmpcpp-ueberzug () {
    while true
    do
	read -p "would you like to install the ncmpcpp-ueberzug script? (displays album art in ncmpcpp) [requires pip+ueberzug installed] [y/n]" yn
	case $yn in
	    [yY] ) echo installing ncmpcpp-ueberzug;
		   install_ncmpcpp-ueberzug && break;;
	    [nN] ) echo skipping ncmpcpp-ueberzug...; break;;
	    * ) echo invalid response;;
	esac
    done
}

# Installs authy 2fa.
install_authy () {
	yay -S authy-electron
}

# Confirmation for authy.
confirm_authy () {
	while true
        do
        read -p "would you like to install authy? (two-factor authenticator) [requires yay] [y/n]" yn
 
        case $yn in
        [yY] ) echo installing authy...;
               install_authy && break;;
        [nN] ) echo skipping authy...; break;;
           * ) echo invalid response;;
        esac
done
}

# Installs discord.
install_discord () {
	yay -S discord_arch_electron mpd-discord-rpc-git
}

# Confirmation for discord.
confirm_discord () {
	while true
	do
	read -p "would you like to install discord? (remember to disable hardware acceleration in the voice/video settings!) [requires yay] [y/n]" yn

        case $yn in 
	[yY] ) echo installing discord...;
               install_discord && break;;
        [nN] ) echo skipping discord...; break;;
           * ) echo invalid response;;
        esac
done
}

# Installs steam.
install_steam () {
    sudo pacman -S gamemode;
    yay -S steam mangohud;
    mkdir ~/.local/share/Steam/compatibilitytools.d/
    
}

# Confirmation for steam.
confirm_steam () {
	while true
	do
	read -p "would you like to install steam? [requires yay] [y/n]" yn

        case $yn in [yY] ) echo installing steam...;
              install_steam && echo "steam is installed. the directory ~/.local/share/Steam/compatibilitytools.d/ has been created. please download the glorious eggroll version of proton from github, and extract it in that directory." && sleep 3 && break;;
       [nN] ) echo skipping steam...; break;;
          * ) echo invalid response;;
        esac done
}

# Install the heroic games launcher
install_heroic () {
	yay -S heroic-games-launcher
}

# Confirmation for heroic games.
confirm_heroic () {
	while true
        do
        read -p "would you like to install the heroic games launcher? (open source launcher for epic games/gog) [requires yay] [y/n]" yn

        case $yn in
        [yY] ) echo installing the heroic games launcher...;
               install_heroic && break;;
        [nN] ) echo skipping heroic...; break;;
           * ) echo invalid response;;
        esac
done
}


# Installs ani-cli - the command-line tool to stream/download anime.
install_ani () { 
	sudo pacman -S axel curl mpv openssl ffmpeg;
	git clone "https://github.com/pystardust/ani-cli.git" && cd ./ani-cli;
	sudo cp ./ani-cli /usr/local/bin;
	cd .. && rm -rf "./ani-cli"
}

# Confirmation for ani-cli.
confirm_ani () {
	while true
        do
        read -p "would you like to install ani-cli? (command line interface for anime streaming) [y/n]" yn

        case $yn in
	[yY] ) echo installing ani-cli...;
               install_ani && break;;
        [nN] ) echo skipping ani-cli...; break;;
           * ) echo invalid response;;
        esac
done
}

# Installs manga-cli - the command-line tool to download/read manga.
install_manga () {
	sudo pacman -S zathura zathura-cb zathura-pdf-poppler;
	yay -S manga-cli-git;
}

# Confirmation for manga-cli.
confirm_manga () {
	while true
        do
        read -p "would you like to install manga-cli? (command line interface for reading manga) [requires yay] [y/n]" yn

        case $yn in
        [yY] ) echo installing manga-cli...;
               install_manga && break;;
        [nN] ) echo skipping manga-cli...; break;;
           * ) echo invalid response;;
        esac
done
}

# Installs soulseek - a p2p file sharing service. 
install_slsk () {
	yay -S soulseekqt
}

# Confirmation for slsk.
confirm_slsk () {
        while true
        do
        read -p "would you like to install soulseek? (a p2p file sharing service) [requires yay] [y/n]" yn

        case $yn in
        [yY] ) echo installing slsk...;
               install_slsk && break;;
        [nN] ) echo skipping slsk...; break;;
           * ) echo invalid response;;
        esac
done
}

# Installs biglybt - a bittorrent protocol client.
install_bigly () {
	yay -S biglybt
}

# Confirmation for biglybt.
confirm_bigly () {
        while true
        do
        read -p "would you like to install biglybt? (a bittorrent client) [requires yay] [y/n]" yn

        case $yn in
        [yY] ) echo installing biglybt...;
               install_bigly && break;;
        [nN] ) echo skipping bigly...; break;;
           * ) echo invalid response;;
        esac
done
}

# Installs wine (wine is not an emulator) a windows compatibility layer for linux.
install_wine () {
	sudo pacman -S wine winetricks
}

# Confirmation for wine installation.
confirm_wine () {
	while true
        do
        read -p "would you like to install wine? (wine is not an emulator - it is a compatibility layer for linux allowing you to run windows software/games) [y/n]" yn

        case $yn in
        [yY] ) echo installing wine...;
               install_wine && break;;
        [nN] ) echo skipping wine...; break;;
           * ) echo invalid response;;
        esac
done
}

# Installs wineasio (an asio driver implementation for wine)
install_wineasio () {
	sudo pacman -S realtime-privileges;
	yay -S wineasio;
	sudo usermod -aG realtime $(whoami);
	regsvr32 /usr/lib32/wine/i386-windows/wineasio.dll;
	wine64 regsvr32 /usr/lib/wine/x86_64-windows/wineasio.dll;
}

# Confirmation for wineasio.
confirm_wineasio () {
	while true
        do
        read -p "would you like to install wineasio? (an asio driver implementation for wine) [requires yay] [y/n]" yn

        case $yn in
        [yY] ) echo installing wineasio...;
               install_wineasio && break;;
        [nN] ) echo skipping wineasio...; break;;
           * ) echo invalid response;;
        esac
done
}

# Installs reaper (digital audio workstation)
install_reaper () {
	yay -S reaper
}

# Confirmation for reaper.
confirm_reaper () {
        while true
        do
        read -p "would you like to install reaper? (a digital audio workstation) [y/n]" yn

        case $yn in
        [yY] ) echo installing reaper...;
               install_reaper && break;;
        [nN] ) echo skipping reaper...; break;;
           * ) echo invalid response;;
        esac
done
}

# Installs virt-manager + dependencies.
install_vm () {
	sudo pacman -S qemu-desktop virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat;
	sudo systemctl start libvirtd;
	sudo systemctl enable libvirtd;
	echo "you must now edit your /etc/libvirt/libvirtd.conf and uncomment unix_sock_group, unix_sock_ro_perms, and unix_sock_rw_perms" && sleep 3;
	echo "then run 'sudo usermod -aG libvirt $(whoami)' and reboot.";
}

# Confirmation for virt-manager.
confirm_vm () {
	while true
        do
        read -p "would you like to install virt-manager? (a frontend for kvm/qemu) [y/n]" yn

        case $yn in
        [yY] ) echo installing virt-manager...;
               install_vm && break;;
        [nN] ) echo skipping virt-manager...; break;;
           * ) echo invalid response;;
        esac
done
}

# Installs coolero.
install_coolero () {
	flatpak install flathub org.coolero.Coolero
}

# Confirmation for coolero.
confirm_coolero () {
        while true
        do
        read -p "would you like to install coolero? (gui to control nzxt aio coolers) [requires flatpak] [y/n]" yn

        case $yn in
        [yY] ) echo installing coolero...;
               install_coolero && break;;
        [nN] ) echo skipping coolero...; break;;
           * ) echo invalid response;;
        esac
done
}

# Installs openrgb.
install_openrgb () {
	flatpak install flathub org.openrgb.OpenRGB
}

# Confirmation for openrgb.
confirm_openrgb () {
         while true
        do
        read -p "would you like to install openrgb? (gui to control rgb components) [requires flatpak] [y/n]" yn

        case $yn in
        [yY] ) echo installing openrgb...;
               install_openrgb && break;;
        [nN] ) echo skipping openrgb...; break;;
           * ) echo invalid response;;
        esac
done
}

# Installs the dolphin emulator (gamecube/wii)
install_dolphin () {
	flatpak install flathub org.DolphinEmu.dolphin-emu
}

# Confirmation for the dolphin emulator.
confirm_dolphin () {
	while true
	do
	read -p "would you like to install dolphin? (gamecube+wii emulator) [requires flatpak] [y/n]" yn

	case $yn in
	[yY] ) echo installing dolphin emulator...;
               install_dolphin && break;;
        [nN] ) echo skipping dolphin emulator...; break;;
           * ) echo invalid response;;
        esac
done
}

# Installs mupen64plus. (n64 emulator - rosalie241 version)
install_mupen () {
	flatpak install flathub com.github.Rosalie241.RMG
}

# Confirmation for mupen64plus.
confirm_mupen () {
        while true
        do
        read -p "would you like to install mupen64plus? (nintendo 64 emulator - gui made by rosalie241) [requires flatpak] [y/n]" yn

        case $yn in
        [yY] ) echo installing mupen64plus...;
               install_mupen && break;;
        [nN] ) echo skipping mupen64plus...; break;;
           * ) echo invalid response;;
        esac
done
}

# Installs mupen64plus from the aur.
install_mupen_aur () {
    yay -S rmg-git
}

# Confirmation for mupen64plus from the aur.
confirm_mupen_aur () {
    while true
    do
	read -p "would you like to install mupen64plus? (nintendo 64 emulator - gui made by rosalie241) [requires yay] [y/n]" yn

	case $yn in
	    [yY] ) echo installing mupen64plus...;
		   install_mupen_aur && break;;
	    [nN] ) echo skipping mupen64plus...; break;;
	    * ) echo invalid response;;
	esac
    done
}

# Installs rpcs3 (playstation 3 emulator)
install_rpcs3 () {
	flatpak install flathub net.rpcs3.RPCS3
}

# Confirmation for rpcs3.
confirm_rpcs3 () {
        while true
        do
        read -p "would you like to install rpcs3? (playstation 3 emulator) [requires flatpak] [y/n]" yn

        case $yn in
        [yY] ) echo installing rpcs3...;
               install_rpcs3 && break;;
        [nN] ) echo skipping rpcs3...; break;;
           * ) echo invalid response;;
        esac
done
}

# Installs pcsx2 (playstation 2 emulator)
install_pcsx2 () {
	sudo pacman -S pcsx2
}

# Confirmation for pcsx2.
confirm_pcsx2 () {
        while true
        do
        read -p "would you like to install pcsx2? (playstation 2 emulator) [y/n]" yn

        case $yn in
        [yY] ) echo installing pcsx2...;
               install_pcsx2 && break;;
        [nN] ) echo skipping pcsx2...; break;;
           * ) echo invalid response;;
        esac
done
}

# Installs duckstation (playstation aka psx emulator) [flatpak]
install_duckstation () {
	flatpak install flathub org.duckstation.Duckstation
}

# Confirmation for duckstation.
confirm_duckstation () {
        while true
        do
        read -p "would you like to install duckstation? (playstation emulator) [requires flatpak] [y/n]" yn

        case $yn in
        [yY] ) echo installing duckstation...;
               install_duckstation && break;;
        [nN] ) echo skipping duckstation...; break;;
           * ) echo invalid response;;
        esac
done
}

# Installs flycast (dreamcast emulator)
install_flycast () {
flatpak install flathub org.flycast.Flycast
}

# Confirmation for flycast.
confirm_flycast () {
        while true
        do
        read -p "would you like to install flycast? (dreamcast emulator) [requires flatpak] [y/n]" yn
        
	case $yn in
        [yY] ) echo installing flycast...;
               install_flycast && break;;
        [nN] ) echo skipping flycast...; break;;
           * ) echo invalid response;;
        esac
done
}

# The end of script (also the option to re-run it in case you missed one)
script_finish () {
	while true
        do
        read -p "thank you for using KAARBS. in case you missed a package, you can re-run the script. E to exit or R to re-run the script." yn

        case $yn in
        [eE] ) echo exiting KAARBS; exit;;
        [rR] ) echo re-running KAARBS; script_init;;
           * ) echo invalid response;;
        esac 
done
}

# BEGINNING OF SCRIPT

# Welcome/dependencies
script_init

# AUR helper (makes for easier installations of packages from the arch user repository)
confirm_yay

# Flatpak support
confirm_flatpak

# Restart to finish enabling flatpak support
confirm_restart

# Python package manager
confirm_pip

# Awesome window manager
confirm_awesomewm

# Kojiros custom configs
confirm_configs

# Mpc mpd mpv ncmpcpp qjackctl carla pavucontrol [pacman] abgate.lv2 [yay]
confirm_multimedia

# Ueberzug (used to display album art in ncmpcpp)
confirm_ueberzug

# ncmpcpp-ueberzug (displays album art in ncmpcpp)
confirm_ncmpcpp-ueberzug

# Web browser (firefox fork) [yay]
confirm_librewolf

# Web browser (chromium-based) [yay]
confirm_brave

# Gnu emacs
confirm_emacs

# Authy 2fa [yay]
confirm_authy

# Discord client [yay]
confirm_discord

# Steam [yay]
confirm_steam

# Heroic games launcher [yay]
confirm_heroic

# Ani-cli
confirm_ani

# Manga-cli [yay]
confirm_manga

# Soulseek [yay]
confirm_slsk
 
# Biglybt [yay]
confirm_bigly

# Wine (wine is not an emulator)
confirm_wine

# Wineasio (asio driver implementation for wine) [yay]
confirm_wineasio

# Reaper [yay]
confirm_reaper

# Virt-manager
confirm_vm

# Coolero [flatpak]
confirm_coolero

# Openrgb [flatpak]
confirm_openrgb

# Dolphin [flatpak]
confirm_dolphin

# Mupen64plus [flatpak]
confirm_mupen

# Mupen64plus [yay]
confirm_mupen_aur

# Rpcs3 [flatpak]
confirm_rpcs3

# Pcsx2
confirm_pcsx2

# Duckstation [flatpak]
confirm_duckstation

# Flycast [flatpak]
confirm_flycast

# End of script, with the option to exit or re-run the script in case you missed a package.
# Thank you for using KAARBS.
script_finish
