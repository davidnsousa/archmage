#!/usr/bin/env bash

# PACKAGES TO CHOOSE FROM 

ARCHMAGEDIR=$(pwd)

PKGS=(

    # TERMINAL UTILITIES

    gnome-keyring "Gnome pass storage" OFF \
    neofetch "System information tool" OFF \

    # GENERAL UTILITIES

    catfish "File search tool" OFF \
    bitwarden "Password manager" OFF \
    gigolo "(AUR) Access remote filesystems" OFF \
    baobab "Disk usage analyzer" OFF \

    # DEVELOPMENT

    base-devel "Development packages" OFF \
    geany "Text editor" OFF \
    git "Version control" OFF \
    octave "Scientific Programming Language" OFF \
    vscodium-bin "(AUR) VSCode like IDE" OFF \
    rstudio-desktop-bin "(AUR) IDE for R" OFF \
    arduino-ide-bin "(AUR) Arduino IDE" OFF \

    # WEB TOOLS

    chromium "Open-source web browser" OFF \
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
)

# INSTALL YAY

message1="yay is not installed. To continue you need to install yay. Do you whish to install yay?"

if yay --version; then 
    echo
else 
    if whiptail --yesno "$message1" 10 50; then
        cd ${HOME}
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si
        yay --save --nocleanmenu --nodiffmenu
        cd $ARCHMAGEDIR
    else
        exit
    fi
fi 

if whiptail --yesno "Do you whish update your system before continuing?" 10 50; then
    yay
fi

# INSTALL PACKAGES

SELECTION=( $(whiptail --title "Install software" --separate-output --checklist "Select packages:" 24 80 14 "${PKGS[@]}" 3>&1 1>&2 2>&3) )
for PKG in ${SELECTION[@]}; do
    yay -S --noconfirm $PKG
done

# COSTUMIZATION

message2="Costumize XFCE with Archmage package selection and settings? This includes fish, conky, rofi, theming, keyboard shortcuts and other cosmetic changes."

if whiptail --yesno "$message2" 10 70; then

    # INSTALL cosmetic packages

    for PKG in ${COSMETICS[@]}; do
        yay -S --noconfirm $PKG
    done

    # XFCE SETTINGS

    # keyboard shortcuts
    xfconf-query -c xfce4-keyboard-shortcuts -p  "/xfwm4/custom/<Super>d" -r
    xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p  "/xfwm4/custom/<Super>d" -s "show_desktop_key"
    xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p  "/commands/custom/<Super>x" -s "rofi -show"
    xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p  "/commands/custom/<Super>f" -s "thunar"
    xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p  "/commands/custom/<Super>e" -s "xfce4-session-logout"
    xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p  "/commands/custom/<Super>w" -s "exo-open --launch WebBrowser"
    xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p  "/commands/custom/<Super>t" -s "exo-open --launch TerminalEmulator"
    # panel settings
    xfce4-panel-profiles load /usr/share/xfce4-panel-profiles/layouts/Redmond.tar.bz2
    xfconf-query -c xfce4-panel -p /plugins/plugin-1/button-icon -s archlinux-logo
    # terminal settings
    cp config/xfce4/terminal/* ${HOME}/.config/xfce4/terminal
    # applicationsmenu settings
    mkdir ${HOME}/.config/menus
    cp config/menus/* ${HOME}/.config/menus
    # set theme name
    xfconf-query -c xsettings -p /Net/ThemeName -s Arc-Dark-solid
    # set icon theme
    xfconf-query -c xsettings -p /Net/IconThemeName -s Tela 
    # set wallpaper
    xfconf-query -c xfce4-desktop -p $(xfconf-query -c xfce4-desktop -l | grep "0/last-image") -s /usr/share/backgrounds/archlinux/small.png
    # no desktop apps menu
    xfconf-query -c xfce4-desktop -p /desktop-menu/show -s false
    # no save on exit
    xfconf-query -c xfce4-session -p /general/SaveOnExit -s false 

    # ROFI SETTINGS

    mkdir ${HOME}/.config/rofi
    cp config/rofi/* ${HOME}/.config/rofi/

    # CONKY SETTINGS

    mkdir ${HOME}/.config/conky
    cp config/conky/* ${HOME}/.config/conky/

    # FISH SETTINGS

    cd ${HOME}
    echo "exec fish" > .bashrc
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
    cp config/fish/* ${HOME}/.config/fish

    # AUTOSTART

    mkdir ${HOME}/.config/autostart
    cp /usr/share/applications/conky.desktop ${HOME}/.config/autostart
fi

echo
echo "Done! Reboot if necessary."
echo