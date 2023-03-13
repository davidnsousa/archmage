PKGS=(
    xorg-server
    xorg-xkill
    lightdm
    lightdm-gtk-greeter
    xfce4
    xfce4-goodies
    xdg-utils
    gvfs
    htop
    pavucontrol
    network-manager-applet
    conky
    rofi
    arc-solid-gtk-theme
    arc-icon-theme
    ttf-opensans
    breeze-blue-cursor-theme
    fish
    bluez
    bluez-utils
    blueman
    man-db
    xarchiver
)

# INSTALL packages

for PKG in ${PKGS[@]}; do
    yay -S --needed --noconfirm $PKG
done

# ENABLE SERVICES

sudo systemctl enable lightdm.service
sudo systemctl enable NetworkManager.service
sudo systemctl enable bluetooth.service

# SETTINGS

# lightdm settings
sudo cp de/xfce/lightdm/lightdm-gtk-greeter.conf /etc/lightdm
# copy archmage artwork
sudo mkdir /usr/share/backgrounds/archmage
sudo cp art/backgrounds/* /usr/share/backgrounds/archmage
sudo cp art/logo/* /usr/share/pixmaps/
# copy configuration files
cp -r de/xfce/config/* ${HOME}/.config
# autostart apps
mkdir ${HOME}/.config/autostart
cp /usr/share/applications/conky.desktop ${HOME}/.config/autostart
# remove fish greeting
fish -c "set -U fish_greeting"
# choose fish prompt
echo
echo "Costumize fish prompt:"
echo
fish -c "fish_config prompt choose informative; fish_config prompt save"