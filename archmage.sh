#!/usr/bin/env bash

# PACKAGES TO CHOOSE FROM 

PKGS=(

    # TERMINAL UTILITIES

    gnome-keyring "Gnome pass storage" ON \
    neofetch "System information tool" ON \
    zsh "ZSH shell" ON \
    zsh-completion "ZSH Tab completion" ON \

    # GENERAL UTILITIES

    catfish "File search tool" ON \
    bitwarden "Password manager" ON \

    # DEVELOPMENT

    base-devel "Development packages" ON \
    geany "Text editor" ON \
    git "Version control" ON \
    octave "Scientific Programming Language" ON \
    vscodium-bin "(AUR) VSCode like IDE" ON \
    rstudio-desktop-bin "(AUR) IDE for R" ON \
    arduino-ide-bin "(AUR) Arduino IDE" ON \

    # WEB TOOLS

    chromium "Open-source web browser" ON \
    firefox "Mozilla web browser" ON \
    librewolf-bin "(AUR) Customized Firefox" ON \
    thunderbird "Mozilla e-mail client" ON \
    transmission-gtk "BitTorrent client" ON \

    # CLOUD UTILITIES

    megasync-bin "(AUR) MEGA Desktop App" ON \
    thunar-megasync-bin "(AUR) MEGA thunar utility" ON \

    # COMMUNICATIONS

    zoom "(AUR) Video Communications" ON \
    telegram-desktop-bin "(AUR) Messaging service" ON \
    slack-desktop "(AUR) Messaging for office" ON \
    signal-desktop-beta-bin "(AUR) Secure messaging service" ON \

    # MEDIA

    vlc "Media player" ON \

    # GRAPHICS AND DESIGN

    gcolor2 "Gnome color picker" ON \
    gimp "Image editor" ON \
    inkscape "Vector image editor" ON \

    # PRODUCTIVITY

    galculator "Gnome calculator" ON \
    mousepad "Text editor" ON \
    xpdf "PDF reader for X" ON \
    onlyoffice-bin "(AUR) Office suite" ON \
    zotero-bin "(AUR) Reference manager" ON \

    # VIRTUALIZATION

    virtualbox "Virtualization" ON \
    virtualbox-host-modules-arch "Virtualbox linux kernel modules" ON \
    virtualbox-host-modules-dkms "Virtualbox other kernels modules" OFF \

    # PRIVACY AND SECURITY TOOLS

    mullvad-vpn-bin "(AUR) Mullvad VPN service" ON \
    protonmail-bridge-bin "(AUR) Protonmail bidge" ON \

    # OTHER

    stellarium-bin "(AUR) Astronomy software" ON 
)

COSMETICS=(
    rofi "Application launcher" ON \
    arc-solid-gtk-theme "Arc GTK theme" ON \
    arc-icon-theme "Arc icon theme" ON \
    xfce4-panel-profiles "(AUR) Panel profiles for XFCE" ON
)

# INSTALL YAY

if yay --version; then 
    echo
else 
    if whiptail --yesno "yay is not installed. To use this script you need an AUR helper that extends to pacman. Do you whish to install yay?" 10 50; then
        cd ${HOME}
        echo "INSTALL YAY"
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si
        yay --save --nocleanmenu --nodiffmenu
        cd ${HOME}
        rm -r yay
    else
        echo "OK!"
    fi
fi 

# SELECT PACKAGES

SELECTION=( $(whiptail --title "Install software" --separate-output --checklist "Select packages:" 24 80 14 "${PKGS[@]}" 3>&1 1>&2 2>&3) )

# INSTALL PACKAGES

if whiptail --yesno "Continue installation?" 10 50; then
    for PKG in ${SELECTION[@]}; do
        yay -S $PKG
    done
else
    echo "OK!"
fi

# COSTUMIZATION

if whiptail --yesno "Costumize XFCE?" 10 50; then
    SELECTIONCOS=( $(whiptail --title "Theming & utilities" --separate-output --checklist "Select packages (official):" 24 80 14 "${COSMETICS[@]}" 3>&1 1>&2 2>&3) )
    for PKG in ${SELECTIONCOS[@]}; do
        yay -S $PKG
    done 
    cp -r config/xfce4/xfconf/xfce-perchannel-xml/. ${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/
else
    echo "OK!"
fi

echo
echo "Done! Reboot if necessary."
echo