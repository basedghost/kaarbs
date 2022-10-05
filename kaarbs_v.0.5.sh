#!/bin/bash

# KAARBS: Kojiros Automated Arch Ricing Bash Script
# ##################################################
# This script is intended to be a quick/lazy way of auto-installing all the packages I normally 
# would but with the option to pick and choose what you want to install. This is mainly for my 
# personal use, however others could use it. Because of my lack of technical knowledge
# it does still require a slight amount of tinkering afterwards, but this should do for now.

# LIST OF FUNCTIONS

# Color coded text.
# No Color
NC='\033[0m'

# Red
RED='\033[0;31m'

#Cyan
CYAN='\033[0;36m'

#Yellow
YELLOW='\033[0;33m'

# Installs dependencies.
install_dep () {
	echo -e "${NC}proceeding to install necessary dependencies..." && sleep 2; 
	sudo pacman -S rsync noto-fonts noto-fonts-cjk noto-fonts-emoji terminus-font pacman-contrib arandr ufw neofetch qt5-base qt5-svg qt5-quickcontrols qt5-quickcontrols2 qt5-graphicaleffects qt5-multimedia zip unzip unrar p7zip ntfs-3g logrotate;
	systemctl enable ufw;
	sudo ufw enable
}

# Confirmation of script initialization.
script_init () {
        while true
        do
        read -p "$(echo -e ${NC}Welcome to ${YELLOW}KAARBS (Kojiros Automated Arch Ricing Bash Script)${NC}."$'\n'"This script gives you the option to install my preferred packages/configs."$'\n'"Before running this script, please make sure that you've read the README, and that your system is completely up to date."$'\n'"${CYAN}(P)roceed,(E)xit,(L)ist packages or (S)kip ahead if re-running script. [p/e/l/s]:)" yn

        case $yn
        in [pP] ) echo -e "${NC}installing dependencies";
                  install_dep && break;;
           [eE] ) echo -e "${RED}exiting KAARBS"; exit;;
           [lL] ) echo -e "rsync"$'\n'"noto-fonts"$'\n'"noto-fonts-cjk"$'\n'"noto-fonts-emoji"$'\n'"terminus-font"$'\n'"pacman-contrib"$'\n'"arandr"$'\n'"ufw"$'\n'"neofetch"$'\n'"qt5-base"$'\n'"qt5-svg"$'\n'"qt5-quickcontrols"$'\n'"qt5-quickcontrols2"$'\n'"qt5-graphicaleffects"$'\n'"qt5-multimedia"; script_init;;
	   [sS] ) echo -e "${RED}skipping dependencies..."; break;;
              * ) echo -e "${YELLOW}invalid response";;
        esac
done
}

# Installs nvidia settings package.
install_nvidia () {
	sudo pacman -S nvidia-settings
}
	
# Confirmation of nvidia-settings installation.
confirm_nvidia () {
	while true
	do
	read -p "${NC}do you have an nvidia gpu? [y/n/s]:" yn
	
	case $yn
	in [yY] ) echo -e "${NC}installing nvidia settings";
		  install_nvidia && break;;
	   [nN] ) echo -e "${RED}skipping nvidia settings..."; break;;
	   [sS] ) echo -e "${RED}skipping dependency..."; break;;
	      * ) echo -e "${YELLOW}invalid response";;
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
	read -p "${NC}would you like to install the aur helper, yay? ${RED}[*HIGHLY RECOMMENDED* - REQUIRED FOR MOST PACKAGES IN THIS SCRIPT]${CYAN}[y/n]:" yn

	case $yn
	in [yY] ) echo -e "${NC}installing yay";
		  install_yay && break;;
	   [nN] ) echo -e "${RED}skipping yay..."; break;;
	      * ) echo -e "${YELLOW}invalid response";;
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
        read -p "${NC}would you like to enable the flathub repository? ${RED}[*HIGHLY RECOMMENDED* - REQUIRED FOR MOST PACKAGES IN THIS SCRIPT] ${CYAN}[y/n]:" yn

        case $yn
        in [yY] ) echo -e "${NC}enabling flatpaks (you will need to reboot after it has completed)";
                  install_flatpak && break;;
           [nN] ) echo -e "${RED}skipping flatpak repo..."; break;;
              * ) echo -e "${YELLOW}invalid response";;
        esac
done
} 

# Confirmation for rebooting to finish enabling flathub repo.
confirm_restart () {
        while true
        do
        read -p "${NC}if you enabled the flathub repo, you must reboot your system to install flatpaks."$'\n'"would you like to reboot now? [run this script again after rebooting to continue] ${CYAN}[y/n]:" yn

        case $yn
        in [yY] ) echo -e "${NC}rebooting...";
                  restart_flatpak;;
           [nN] ) echo -e "${RED}skipping reboot..."; break;;
              * ) echo -e "${YELLOW}invalid response";;
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
	read -p "${NC}would you like to install pip - the python package manager? ${RED}[only required to install ueberzug] ${CYAN}[y/n]:" yn

	case $yn
	in [yY] ) echo -e "${NC}installing pip";
		  install_pip && break;;
	   [nN] ) echo -e "${RED}skipping pip..."; break;;
	   * ) echo -e "${YELLOW}invalid response";;
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
}

# Confirmation of awesomewm installation.
confirm_awesomewm () {
	while true
	do
	read -p "${NC}would you like to install awesomeWM - the dynamic window manager?(Y)es, (N)o, or (L)ist packages ${CYAN}[y/n/l]:" yn

        case $yn in
	[yY] ) echo -e "${NC}installing awesomeWM";
               install_awesomewm && break;;
        [nN] ) echo -e "${RED}skipping awesomeWM..."; break;;
        [lL] ) echo -e "${CYAN}awesome\nnitrogen\npicom\nxorg-xwininfo\nxorg-xprop\nxscreensaver\ndmenu\npolkit-gnome\nkitty\nunclutter\nlxappearance\npavucontrol\npcmanfm\nscrot\nfeh\nimagemagick\nconky"; confirm_awesomewm;;
           * ) echo -e "${YELLOW}invalid response";;
        esac
done
}	

# Installs simple desktop display manager + a custom lain theme.
install_sddm () {
     sudo pacman -S sddm;
     systemctl enable sddm;
     git clone https://aur.archlinux.org/sddm-lain-wired-theme.git;
     cd sddm-lain-wired-theme;
     makepkg -Ccsi;
     cd;
     echo -e "[Theme]"$'\n'"Current=sddm-lain-wired-theme">>sddm.conf;
     sudo cp sddm.conf /etc/sddm.conf
}

# Confirmation of sddm installation.
confirm_sddm () {
while true
	do
	read -p "${NC}would you like to install sddm - a login screen manager? ${CYAN}[y/n]:" yn

        case $yn in
	[yY] ) echo -e "${NC}installing + enabling sddm";
               install_sddm && break;;
        [nN] ) echo -e "${RED}skipping sddm..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
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
    sudo cp -r usr/ /
    cd /usr/local/bin/
    sudo chmod +x FL;
    sudo chmod +x awesome_display_layout.sh;
    sudo chmod +x graal;
    sudo chmod +x lock.sh;
    sudo chmod +x matrix.sh;
    sudo chmod +x noisegate;
    sudo chmod +x nrestore.sh;
    sudo chmod +x pwrestart;
    sudo chmod +x screentearfix.sh;
    sudo chmod +x sleep.sh;
    sudo chmod +x webcam;
    cd ~/dotfiles/
    
# Clones the /etc/ directory
    sudo cp -r etc/ /

# Clones the local directory
    rsync -vrP .local/ ~/.local/
    
# Bashrc
    mv bashrc ~/.bashrc

# Gnu emacs config
    mv emacs ~/.emacs;
    rsync -vrP Pictures/ ~/Pictures/

# Xscreensaver config
    mv xscreensaver ~/.xscreensaver
    
# Noise gate config file for carla
    mv audio.carxp ~/audio.carxp

# Custom sudo lecture (requires the use of the sudo visudo command to add the lines "Defaults lecture=always" and "Defaults lecture_file=/home/user/lecture")
    mv lecture ~/lecture

# Ffmpeg batch convert script
    chmod +x ffmpeg-batch.sh && mv ffmpeg-batch.sh ~/ffmpeg-batch.sh
    
# Installs figlet
   sudo pacman -S figlet;
 
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
        read -p "${NC}would you like to install kojiros custom configs/themes? ${CYAN}[y/n]:" yn

        case $yn in
        [yY] ) echo -e "${NC}installing kojiros configs/themes";
               install_configs && break;;
        [nN] ) echo -e "${RED}skipping configs..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
        esac
done
}

# Installs oh-my-bash, custom themes for bash shell.
install_omb () {
     sudo pacman -S curl;
     bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
}

confirm_omb () {
    while true
        do
        read -p "${NC}would you like to install oh-my-bash (custom bash themes)? ${CYAN}[y/n]:" yn

        case $yn in
        [yY] ) echo -e "${NC}installing oh my bash";
               install_omb && break;;
        [nN] ) echo -e "${RED}skipping oh my bash..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
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
	read -p "${NC}would you like to install the librewolf web browser? ${RED}[requires yay]${CYAN}[y/n]:" yn

	case $yn in
	[yY] ) echo -e "${NC}installing librewolf";
               install_librewolf && break;;
        [nN] ) echo -e "${RED}skipping librewolf..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
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
	read -p "${NC}would you like to install the brave web browser? ${RED}[requires yay] ${CYAN}[y/n]:" yn
 
        case $yn in
	[yY] ) echo -e "${NC}installing brave";
               install_brave && break;;
        [nN] ) echo -e "${RED}skipping brave..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
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
        read -p "${NC}would you like to install gnu emacs? ${CYAN}[y/n]:" yn

        case $yn in
        [yY] ) echo -e "${NC}installing+enabling emacs";
               install_emacs && break;;
        [nN] ) echo -e "${RED}skipping emacs..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
        esac
done
}

# Installs packages used for multimedia purposes.
install_multimedia () {
	sudo pacman -S carla mpc mpd mpv ncmpcpp qpwgraph pavucontrol;
	yay -S abgate.lv2;
	systemctl --user enable mpd;
	systemctl --user start mpd
}

# Confirmation prompt to install multimedia packages.
confirm_multimedia () {
	while true
	do
	read -p "${NC}would you like to install frequently used multimedia applications? ${RED}[requires yay] ${CYAN}(Y)es, (N)o, or (L)ist packages [y/n/l]:" yn
 
        case $yn in
	[yY] ) echo -e "${NC}installing multimedia packages";
               install_multimedia && break;;
        [nN] ) echo -e "${RED}skipping multimedia stuff..."; break;;
	[lL] ) echo -e "${CYAN}carla\nmpc\nmpd\nmpv\nncmpcpp\nqpwgraph\npavucontrol"; confirm_multimedia;;
           * ) echo -e "${YELLOW}invalid response";;
        esac
done
}

# Installs krita.
install_krita () {
    flatpak install flathub org.kde.krita
}

# Confirmation for krita.
confirm_krita () {
    while true
    do
	read -p "${NC}would you like to install krita? ${RED}[requires flatpak] ${CYAN}[y/n]:" yn

	case $yn in
	    [yY] ) echo -e "${NC}installing krita";
		   install_krita && break;;
	    [nN] ) echo -e "${RED}skipping krita..."; break;;
	    * ) echo -e "${YELLOW}invalid response";;
	esac
    done
}

# Installs kdenlive.
install_kdenlive () {
	flatpak install flathub org.kde.kdenlive
}

# Confirmation for kdenlive.
confirm_kdenlive () {
	while true
	do
	read -p "${NC}would you like to install kdenlive? ${RED}[requires flatpak] ${CYAN}[y/n]:" yn
	
	case $yn in
	[yY] ) echo -e "${NC}installing kdenlive";
		install_kdenlive && break;;
	[nN] ) echo -e "${RED}skipping kdenlive..."; break;;
	   * ) echo -e "${YELLOW}invalid response";;
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
	read -p "${NC}would you like to install ueberzug? (used by ncmpcpp to display album art) ${RED}[requires pip] ${CYAN}[y/n]:" yn
	case $yn in
	    [yY] ) echo -e "${NC}installing ueberzug";
		   install_ueberzug && break;;
	    [nN] ) echo -e "${RED}skipping ueberzug..."; break;;
	    * ) echo -e "${YELLOW}invalid response";;
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
	read -p "${NC}would you like to install the ncmpcpp-ueberzug script? (displays album art in ncmpcpp) ${RED}[requires pip+ueberzug installed] ${CYAN}[y/n]:" yn
	case $yn in
	    [yY] ) echo -e "${NC}installing ncmpcpp-ueberzug";
		   install_ncmpcpp-ueberzug && break;;
	    [nN] ) echo -e "${RED}skipping ncmpcpp-ueberzug..."; break;;
	    * ) echo -e "${YELLOW}invalid response";;
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
        read -p "${NC}would you like to install authy? (two-factor authenticator) ${RED}[requires yay] ${CYAN}[y/n]:" yn
 
        case $yn in
        [yY] ) echo -e "${NC}installing authy";
               install_authy && break;;
        [nN] ) echo -e "${RED}skipping authy..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
        esac
done
}

# Installs keepassxc.
install_keepassxc () {
	sudo pacman -S keepassxc
}

# Confirmation for keepassxc.
confirm_keepassxc () {
	while true
	do
	read -p "${NC}would you like to install keepassxc? (password manager) ${CYAN}[y/n]:" yn
	
	case $yn in
	[yY] ) echo -e "${NC}installing keepassxc";
	       install_keepassxc && break;;
	[nN] ) echo -e "${RED}skipping keepassxc..."; break;;
	   * ) echo -e "${YELLOW}invalid response";;
	esac
done
}

# Installs discord + rich presence for mpd.
install_discord () {
	sudo pacman -S discord;
	yay -S mpd-discord-rpc-git
}

# Confirmation for discord.
confirm_discord () {
	while true
	do
	read -p "${NC}would you like to install discord? ${RED}(remember to disable hardware acceleration in the voice/video settings!) [also installs mpd-rpc for discord. requires yay] ${CYAN}[y/n]:" yn

        case $yn in 
	[yY] ) echo -e "${NC}installing discord";
               install_discord && break;;
        [nN] ) echo -e "${RED}skipping discord..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
        esac
done
}

# Installs steam + gamemode & mangohud.
install_steam () {
    sudo pacman -S gamemode;
    yay -S steam mangohud;
    mkdir ~/.local/share/Steam/compatibilitytools.d/
    
}

# Confirmation for steam.
confirm_steam () {
	while true
	do
	read -p "${NC}would you like to install steam? ${RED}[requires yay] ${CYAN}[y/n]:" yn

        case $yn in
	[yY] ) echo -e "${NC}installing steam";
              install_steam && echo -e "${YELLOW}steam is installed. the directory ~/.local/share/Steam/compatibilitytools.d/ has been created."$'\n'"${YELLOW}please download the glorious eggroll version of proton from github, and extract it in that directory." && sleep 3 && break;;
       [nN] ) echo -e "${RED}skipping steam..."; break;;
          * ) echo -e "${YELLOW}invalid response";;
        esac
done
}

# Install the heroic games launcher
install_heroic () {
	yay -S heroic-games-launcher
}

# Confirmation for heroic games.
confirm_heroic () {
	while true
        do
        read -p "${NC}would you like to install the heroic games launcher? (open source launcher for epic games/gog) ${RED}[requires yay] ${CYAN}[y/n]:" yn

        case $yn in
        [yY] ) echo -e "${NC}installing the heroic games launcher";
               install_heroic && break;;
        [nN] ) echo -e "${RED}skipping heroic..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
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
        read -p "${NC}would you like to install ani-cli? (command line interface for anime streaming) ${CYAN}[y/n]:" yn

        case $yn in
	[yY] ) echo -e "${NC}installing ani-cli";
               install_ani && break;;
        [nN] ) echo -e "${RED}skipping ani-cli..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
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
        read -p "${NC}would you like to install manga-cli? (command line interface for reading manga) ${RED}[requires yay] ${CYAN}[y/n]:" yn

        case $yn in
        [yY] ) echo -e "${NC}installing manga-cli";
               install_manga && break;;
        [nN] ) echo -e "${RED}skipping manga-cli..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
        esac
done
}

# Installs trash-cli.
install_trash () {
	sudo pacman -S trash-cli
}

# Confirmation for trash-cli.
confirm_trash () {
	while true
	do
	read -p "${NC}would you like to install trash-cli? (command line tool for emptying trash)${CYAN}[y/n]:" yn
	
	case $yn in
	[yY] ) echo -e "${NC}installing trash-cli";
	       install_trash && break;;
	[nN] ) echo -e "${RED}skipping trash-cli..."; break;;
	   * ) echo -e "${YELLOW}invalid response";;
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
        read -p "${NC}would you like to install soulseek? (a p2p file sharing service) ${RED}[requires yay] ${CYAN}[y/n]:" yn

        case $yn in
        [yY] ) echo -e "${NC}installing slsk";
               install_slsk && break;;
        [nN] ) echo -e "${RED}skipping slsk..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
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
        read -p "${NC}would you like to install biglybt? (a bittorrent client) ${RED}[requires yay] ${CYAN}[y/n]:" yn

        case $yn in
        [yY] ) echo -e "${NC}installing biglybt";
               install_bigly && break;;
        [nN] ) echo -e "${RED}skipping bigly..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
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
        read -p "${NC}would you like to install wine? (wine is not an emulator - it is a compatibility layer for linux allowing you to run windows software/games) ${CYAN}[y/n]:" yn

        case $yn in
        [yY] ) echo -e "${NC}installing wine";
               install_wine && break;;
        [nN] ) echo -e "${RED}skipping wine..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
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
        read -p "${NC}would you like to install wineasio? (an asio driver implementation for wine) ${RED}[requires yay] ${CYAN}[y/n]:" yn

        case $yn in
        [yY] ) echo -e "${NC}installing wineasio";
               install_wineasio && break;;
        [nN] ) echo -e "${RED}skipping wineasio..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
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
        read -p "${NC}would you like to install reaper? (a digital audio workstation) ${CYAN}[y/n]:" yn

        case $yn in
        [yY] ) echo -e "${NC}installing reaper";
               install_reaper && break;;
        [nN] ) echo -e "${RED}skipping reaper..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
        esac
done
}

# Installs virt-manager + dependencies.
install_vm () {
	sudo pacman -S qemu-desktop virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat;
	sudo systemctl start libvirtd;
	sudo systemctl enable libvirtd;
	echo -e "${YELLOW}you must now edit your /etc/libvirt/libvirtd.conf and uncomment:"$'\n'"${CYAN}unix_sock_group, unix_sock_ro_perms, and unix_sock_rw_perms" && sleep 3;
	echo -e "${YELLOW}then run 'sudo usermod -aG libvirt $(whoami)' and reboot.";
}

# Confirmation for virt-manager.
confirm_vm () {
	while true
        do
        read -p "${NC}would you like to install virt-manager? (a frontend for kvm/qemu) ${CYAN}[y/n]:" yn

        case $yn in
        [yY] ) echo -e "${NC}installing virt-manager";
               install_vm && break;;
        [nN] ) echo -e "${RED}skipping virt-manager..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
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
        read -p "${NC}would you like to install coolero? (gui to control aio coolers) ${RED}[requires flatpak] ${CYAN}[y/n]:" yn

        case $yn in
        [yY] ) echo -e "${NC}installing coolero";
               install_coolero && break;;
        [nN] ) echo -e "${RED}skipping coolero..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
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
        read -p "${NC}would you like to install openrgb? (gui to control rgb components) ${RED}[requires flatpak] ${CYAN}[y/n]:" yn

        case $yn in
        [yY] ) echo -e "${NC}installing openrgb";
               install_openrgb && break;;
        [nN] ) echo -e "${RED}skipping openrgb..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
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
	read -p "${NC}would you like to install dolphin? (gamecube+wii emulator) ${RED}[requires flatpak] ${CYAN}[y/n]:" yn

	case $yn in
	[yY] ) echo -e "${NC}installing dolphin emulator";
               install_dolphin && break;;
        [nN] ) echo -e "${RED}skipping dolphin emulator..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
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
        read -p "${NC}would you like to install mupen64plus? (nintendo 64 emulator - gui made by rosalie241) ${RED}[requires flatpak] ${CYAN}[y/n]:" yn

        case $yn in
        [yY] ) echo -e "${NC}installing mupen64plus";
               install_mupen && break;;
        [nN] ) echo -e "${RED}skipping mupen64plus..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
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
	read -p "${NC}would you like to install mupen64plus? (nintendo 64 emulator - gui made by rosalie241) ${RED}[requires yay] ${CYAN}[y/n]:" yn

	case $yn in
	    [yY] ) echo -e "${NC}installing mupen64plus";
		   install_mupen_aur && break;;
	    [nN] ) echo -e "${RED}skipping mupen64plus..."; break;;
	    * ) echo -e "${YELLOW}invalid response";;
	esac
    done
}

# Installs rpcs3 (playstation 3 emulator)
install_rpcs3 () {
	yay -S rpcs3-bin
}

# Confirmation for rpcs3.
confirm_rpcs3 () {
        while true
        do
        read -p "${NC}would you like to install rpcs3? (playstation 3 emulator) ${RED}[requires yay] ${CYAN}[y/n]:" yn

        case $yn in
        [yY] ) echo -e "${NC}installing rpcs3";
               install_rpcs3 && break;;
        [nN] ) echo -e "${RED}skipping rpcs3..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
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
        read -p "${NC}would you like to install pcsx2? (playstation 2 emulator) ${CYAN}[y/n]:" yn

        case $yn in
        [yY] ) echo -e "${NC}installing pcsx2";
               install_pcsx2 && break;;
        [nN] ) echo -e "${RED}skipping pcsx2..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
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
        read -p "${NC}would you like to install duckstation? (playstation emulator) ${RED}[requires flatpak] ${CYAN}[y/n]:" yn

        case $yn in
        [yY] ) echo -e "${NC}installing duckstation";
               install_duckstation && break;;
        [nN] ) echo -e "${RED}skipping duckstation..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
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
        read -p "${NC}would you like to install flycast? (dreamcast emulator) ${RED}[requires flatpak] ${CYAN}[y/n]:" yn
        
	case $yn in
        [yY] ) echo -e "${NC}installing flycast";
               install_flycast && break;;
        [nN] ) echo -e "${RED}skipping flycast..."; break;;
           * ) echo -e "${YELLOW}invalid response";;
        esac
done
}

# The end of script (also the option to re-run it in case you missed one)
script_finish () {
	while true
        do
        read -p "$(echo -e ${NC}thank you for using KAARBS."$'\n'"${NC}In case you missed a package, you can re-run the script."$'\n'"${CYAN}(E)xit or (R)e-run the script.)" yn

        case $yn in
        [eE] ) echo -e "${RED}exiting KAARBS"; exit;;
        [rR] ) echo -e "${YELLOW}re-running KAARBS"; script_init;;
           * ) echo -e "${YELLOW}invalid response";;
        esac 
done
}

# BEGINNING OF SCRIPT

# Welcome/dependencies
script_init

# Nvidia settings (optional dependency)
confirm_nvidia

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

# Simple desktop display manager
confirm_sddm

# Kojiros custom configs
confirm_configs

# Oh my bash
confirm_omb

# Mpc mpd mpv ncmpcpp qjackctl carla pavucontrol [pacman] abgate.lv2 [yay]
confirm_multimedia

# Krita
confirm_krita

# Kdenlive
confirm_kdenlive

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

# Keepassxc
confirm_keepassxc

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

# Trash-cli
confirm_trash

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
