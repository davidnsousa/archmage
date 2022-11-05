#!/usr/bin/env bash

# PKGS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

PKGS=(

    # TERMINAL UTILITIES

    gnome-keyring "Gnome pass storage" OFF \
    neofetch "System information tool" OFF \

    # GENERAL UTILITIES

    catfish "File search tool" OFF \
    bitwarden "Cloud password manager" OFF \
    keepass "Password manager" OFF \
    gigolo "(AUR) Access remote filesystems" OFF \
    baobab "Disk usage analyzer" OFF \

    # DEVELOPMENT

    base-devel "Development packages" OFF \
    emacs "Text editor" OFF \
    geany "Text editor" OFF \
    git "Version control" OFF \
    octave "Scientific Programming Language" OFF \
    vscodium-bin "(AUR) VSCode like IDE" OFF \
    rstudio-desktop-bin "(AUR) IDE for R" OFF \
    arduino-ide-bin "(AUR) Arduino IDE" OFF \

    # WEB TOOLS

    chromium "Open-source web browser" OFF \
    google-chrome "(AUR) Google chrome browser" OFF \
    firefox "Mozilla web browser" OFF \
    librewolf-bin "(AUR) Customized Firefox" OFF \
    thunderbird "Mozilla e-mail client" OFF \
    transmission-gtk "BitTorrent client" OFF \

    # CLOUD UTILITIES

    megasync-bin "(AUR) MEGA Desktop App" OFF \
    thunar-megasync-bin "(AUR) MEGA thunar utility" OFF \

    # COMMUNICATIONS

    zoom "(AUR) Video Communications" OFF \
    telegram-desktop-bin "(AUR) Messaging service" OFF \
    slack-desktop "(AUR) Messaging for office" OFF \
    signal-desktop-beta-bin "(AUR) Secure messaging service" OFF \

    # MEDIA

    vlc "Media player" OFF \
    lmms "Linux multi-media studio" OFF \

    # GRAPHICS AND DESIGN

    gcolor2 "Gnome color picker" OFF \
    gimp "Image editor" OFF \
    inkscape "Vector image editor" OFF \

    # PRODUCTIVITY

    galculator "Gnome calculator" OFF \
    mousepad "Text editor" OFF \
    xpdf "PDF reader for X" OFF \
    atril "PDF reader" OFF \
    onlyoffice-bin "(AUR) Office suite" OFF \
    zotero-bin "(AUR) Reference manager" OFF \

    # VIRTUALIZATION

    virtualbox "Virtualization" OFF \
    virtualbox-host-modules-arch "Virtualbox linux kernel modules" OFF \
    virtualbox-host-modules-dkms "Virtualbox other kernels modules" OFF \

    # PRIVACY AND SECURITY TOOLS

    mullvad-vpn-bin "(AUR) Mullvad VPN service" OFF \
    protonmail-bridge-bin "(AUR) Protonmail bidge" OFF \

    # OTHER

    stellarium-bin "(AUR) Astronomy software" OFF 
)

# FUNC >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

menu () {
    CHOICES=$(whiptail --title "Archmage" --menu "" --default-item "$1" 18 50 10 \
    1 "Install yay (if not installed)" \
    2 "Update system" \
    3 "Install software" \
    4 "Setup DE" \
    5 "All" 3>&1 1>&2 2>&3)

    if [ -z $CHOICES ]; then
    echo "Ok"
    else
    for CHOICE in $CHOICES; do
        case "$CHOICE" in
        1)
        install_yay
        ;;
        2)
        update_system
        ;;
        3)
        install_packages
        ;;
        4)
        setup_DE
        ;;
        5)
        AUTOMATIC=true
        install_yay
        update_system 
        install_packages
        setup_DE
        if whiptail --yesno "Finished! Do you wish to reboot now?" 10 50; then
            reboot
            else
            AUTOMATIC=false
            menu 5
        fi
        ;;
        esac
    done
    fi
}

# INSTALL YAY

install_yay () {
    if yay --version; then 
        echo "yay is already installed!"
    else 
        cd ${HOME}
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si
        yay --save --nocleanmenu --nodiffmenu
        cd $ARCHMAGEDIR
    fi 
    if ! $AUTOMATIC; then menu 2; fi
}

update_system () {
    yay
    if ! $AUTOMATIC; then menu 3; fi
}

# INSTALL PACKAGES

install_packages () {
    SELECTION=( $(whiptail --title "Install software" --separate-output --checklist "Select packages:" 24 80 14 "${PKGS[@]}" 3>&1 1>&2 2>&3) )
    for PKG in ${SELECTION[@]}; do
        yay -S --noconfirm $PKG
    done
    if ! $AUTOMATIC; then menu 4; fi
}

# DESKTOP ENVIRONMENT SETUP

setup_DE () {
    sh setupDE.sh
    menu 4
}

# RUN >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

ARCHMAGEDIR=$(pwd)

AUTOMATIC=false

menu 5

echo
echo "Done! Reboot if necessary."
echo