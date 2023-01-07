PKGS=(
    xorg-server
    lightdm
    lightdm-gtk-greeter
    xfce4
    xfce4-goodies
    xdg-utils
    gvfs
    pavucontrol
    network-manager-applet
    conky
    rofi
    arc-solid-gtk-theme
    arc-icon-theme
    ttf-opensans
    breeze-blue-cursor-theme 
)

# INSTALL packages

for PKG in ${PKGS[@]}; do
    yay -S --needed --noconfirm $PKG
done

echo
echo "Enable services:"
echo
sudo systemctl enable lightdm.service
sudo systemctl enable NetworkManager.service

# SETTINGS

# lightdm settings
echo
echo "Costumize lightdm:"
echo
sudo cp config/lightdm/lightdm-gtk-greeter.conf /etc/lightdm
# copy archmage artwork
echo
echo "Copy archmage artwork:"
echo
sudo mkdir /usr/share/backgrounds/archmage
sudo cp imgs/backgrounds/* /usr/share/backgrounds/archmage
sudo cp imgs/logo/* /usr/share/pixmaps/
# copy configuration files
cp -r config/config_xfce/* ${HOME}/.config
# autostart apps
mkdir ${HOME}/.config/autostart
cp /usr/share/applications/conky.desktop ${HOME}/.config/autostart