PKGS=(
    xorg-server
    lightdm
    lightdm-gtk-greeter
    xfce4
    xfce4-goodies
    fish
    conky
    rofi
    arc-solid-gtk-theme
    arc-icon-theme
    archlinux-wallpaper
    xfce4-panel-profiles
    ttf-opensans
    breeze-blue-cursor-theme
    pavucontrol
    volumeicon 
)

# INSTALL packages

for PKG in ${PKGS[@]}; do
    yay -S --needed --noconfirm $PKG
done

echo
echo "Enable lightdm service:"
echo
sudo systemctl enable lightdm.service

# SETTINGS

# lightdm settings
echo
echo "Costumize lightdm:"
echo
sudo cp /usr/share/backgrounds/archlinux/small.png /usr/share/pixmaps
sudo cp config/lightdm/lightdm-gtk-greeter.conf /etc/lightdm
# xfce settings
cp config/xfce4/xfconf/xfce-perchannel-xml/* ${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml
# autostart volumeicon
cp /usr/share/applications/volumeicon.desktop ${HOME}/.config/autostart
# terminal settings
mkdir ${HOME}/.config/xfce4/terminal
cp config/xfce4/terminal/* ${HOME}/.config/xfce4/terminal
# applicationsmenu settings
mkdir ${HOME}/.config/menus
cp config/menus/* ${HOME}/.config/menus
# rofi settings
mkdir ${HOME}/.config/rofi
cp config/rofi/* ${HOME}/.config/rofi
# conky settings
mkdir ${HOME}/.config/conky
cp config/conky/* ${HOME}/.config/conky
# autostart conky
rm ${HOME}/.config/autostart
mkdir ${HOME}/.config/autostart
cp /usr/share/applications/conky.desktop ${HOME}/.config/autostart
# bash settings
echo "exec fish" > ${HOME}/.bashrc
# remove fish greeting
fish -c "set -U fish_greeting"
# choose fish prompt
echo
echo "Costumize fish prompt:"
echo
fish -c "fish_config prompt choose informative; fish_config prompt save"