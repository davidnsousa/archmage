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

COSMETICS=(
    fish
    conky
    rofi
    arc-solid-gtk-theme
    archlinux-wallpaper
    xfce4-panel-profiles
    tela-icon-theme
    ttf-opensans
    breeze-blue-cursor-theme
    breeze-snow-cursor-theme
    breeze-obsidian-cursor-theme     
)

# FUNC >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

menu () {
    CHOICES=$(whiptail --title "Archmage" --menu "" --default-item "$1" 18 50 10 \
    1 "Install yay (if not installed)" \
    2 "Update system" \
    3 "Install software" \
    4 "Costumize Xfce" \
    5 "Do everything" 3>&1 1>&2 2>&3)

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
        constumize_xfce
        ;;
        5)
        AUTOMATIC=true
        install_yay
        update_system 
        install_packages
        constumize_xfce
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

# COSTUMIZATION - needs xfce4 and xfce-goodies

constumize_xfce () {

    # INSTALL cosmetic packages

    for PKG in ${COSMETICS[@]}; do
        yay -S --noconfirm $PKG
    done

    # SETTINGS

    # panel settings
    xfce4-panel-profiles load /usr/share/xfce4-panel-profiles/layouts/Redmond.tar.bz2
    xfconf-query -c xfce4-panel -p /plugins/plugin-1/button-icon -s archlinux-logo
    # add pulseaudio to panel
    xfconf-query -c xfce4-panel -n -t 'string' -p /plugins/plugin-6 -s pulseaudio
    xfconf-query -c xfce4-panel -n -t 'bool' -p /plugins/plugin-6/enable-keyboard-shortcuts -s true
    # add power-manager to panel
    xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/show-tray-icon -s true
    # change panel clock format
    xfconf-query -c xfce4-panel -p /plugins/plugin-5/digital-format -s "%a %_d %b, %R"
    # terminal settings
    mkdir ${HOME}/.config/xfce4/terminal
    cp config/xfce4/terminal/* ${HOME}/.config/xfce4/terminal
    # applicationsmenu settings
    mkdir ${HOME}/.config/menus
    cp config/menus/* ${HOME}/.config/menus
    # set font
    xfconf-query -c xsettings -p /Gtk/FontName -s "Open Sans 10"
    # set gtk theme
    xfconf-query -c xsettings -p /Net/ThemeName -s Arc-Dark-solid
    # set window manager theme
    xfconf-query -c xfwm4 -p /general/theme -s Arc-Dark-solid
    # set icon theme
    xfconf-query -c xsettings -p /Net/IconThemeName -s Tela
    # set cursor theme
    xfconf-query -c xsettings -p /Gtk/CursorThemeName -s Breeze_Blue
    # set wallpaper
    xfconf-query -c xfce4-desktop -p $(xfconf-query -c xfce4-desktop -l | grep "0/last-image") -s /usr/share/backgrounds/archlinux/small.png
    # no desktop apps menu
    xfconf-query -c xfce4-desktop -n -t 'bool' -p /desktop-menu/show -s false
    # no save on exit
    xfconf-query -c xfce4-session -n -t 'bool' -p /general/SaveOnExit -s false 
    # no window cycle preview
    xfconf-query -c xfwm4 -p /general/cycle_preview -s false
    # lightdm settings
    sudo cp /usr/share/backgrounds/archlinux/small.png /usr/share/pixmaps
    sudo cp config/lightdm/lightdm-gtk-greeter.conf /etc/lightdm
    # rofi settings
    mkdir ${HOME}/.config/rofi
    cp config/rofi/* ${HOME}/.config/rofi
    # conky settings
    mkdir ${HOME}/.config/conky
    cp config/conky/* ${HOME}/.config/conky
    # autostart
    mkdir ${HOME}/.config/autostart
    cp /usr/share/applications/conky.desktop ${HOME}/.config/autostart
    # bash settings
    echo "exec fish" > ${HOME}/.bashrc
    # remove fish greeting
    fish -c "set -U fish_greeting"
    # choose fish prompt
    fish -c "fish_config prompt choose informative; fish_config prompt save"
    # keyboard shortcuts
    xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p  "/commands/custom/<Super>x" -s "rofi -show"
    xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p  "/commands/custom/<Super>f" -s "thunar"
    xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p  "/commands/custom/<Super>e" -s "xfce4-session-logout"
    xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p  "/commands/custom/<Super>w" -s "exo-open --launch WebBrowser"
    xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p  "/commands/custom/<Super>t" -s "exo-open --launch TerminalEmulator"
    xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p  "/xfwm4/custom/<Super>q" -s "close_window_key"
    xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p  "/xfwm4/custom/<Super>d" -s "show_desktop_key"    

    menu 4
}

# RUN >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

ARCHMAGEDIR=$(pwd)

AUTOMATIC=false

menu 5

echo
echo "Done! Reboot if necessary."
echo