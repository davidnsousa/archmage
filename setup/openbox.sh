PKGS=(
    xorg-server
    xorg-xinit
    xorg-xkill
    xorg-xev
    xdg-utils
    xterm
    xcompmgr
    gvfs
    htop
    pavucontrol
    network-manager-applet
    light
    openbox-arc-git
    arc-solid-gtk-theme
    arc-icon-theme
    ttf-dejavu
    fish
    bluez
    bluez-utils
    blueman
    man-db
    pcmanfm
    arandr
    dunst
    mirage
    geany
    xarchiver
    xf86-input-synaptics
    gscreenshot
    ttf-font-awesome
    lemonbar-xft-git
    wmctrl
    dmenu
    pactl
    feh
)

# INSTALL packages

for PKG in ${PKGS[@]}; do
    yay -S --needed --noconfirm $PKG
done

# ENABLE SERVICES
sudo systemctl enable NetworkManager.service
sudo systemctl enable bluetooth.service

# need to add $user to group video do control backlight with light
sudo gpasswd -a $USER video

# SETTINGS

# copy configuration files
cp de/openbox/xinitrc ${HOME}/.xinitrc
cp -r de/openbox/config/* ${HOME}/.config
cp de/openbox/gtkrc-2.0 ${HOME}/.gtkrc-2.0
cp de/openbox/bashrc ${HOME}/.bashrc
cp de/openbox/Xresources ${HOME}/.Xresources
sudo cp de/openbox/70-synaptics.conf /etc/X11/xorg.conf.d/
# remove fish greeting
fish -c "set -U fish_greeting"
# choose fish prompt
echo
echo "Costumize fish prompt:"
echo
fish -c "fish_config prompt choose informative; fish_config prompt save"
echo fish > .bashrc
