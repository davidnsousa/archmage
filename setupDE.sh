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
    volumeicon 
)

# INSTALL packages

for PKG in ${PKGS[@]}; do
    yay -S --needed --noconfirm $PKG
done

sudo systemctl enable lightdm.service

# SETTINGS

# panel settings
xfce4-panel-profiles load /usr/share/xfce4-panel-profiles/layouts/Redmond.tar.bz2
xfconf-query -c xfce4-panel -p /plugins/plugin-1/button-icon -s archlinux-logo
# autostart volumeicon
cp /usr/share/applications/volumeicon.desktop ${HOME}/.config/autostart
volumeicon &
# add power-manager to panel
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/show-tray-icon -s true
# change panel clock format
xfconf-query -c xfce4-panel -p /plugins/plugin-5/digital-format -s "%a %_d %b, %R"
# no icons in pabel menu
xfconf-query -c xfce4-panel -p /plugins/plugin-1/show-menu-icons -s false
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
xfconf-query -c xsettings -p /Net/IconThemeName -s Arc
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
# keyboard shortcuts
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p "/commands/custom/<Super>a" -s "pavucontrol"
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p "/commands/custom/<Super>x" -s "rofi -show"
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p "/commands/custom/<Super>z" -s "rofi -show filebrowser -config ~/.config/rofi/config_file_browser.rasi"
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p "/commands/custom/<Super>f" -s "thunar"
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p "/commands/custom/<super>s" -s "bash -c 'sh ~/.config/rofi/search_home.sh'"
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p "/commands/custom/<super>e" -s "bash -c 'sh ~/.config/rofi/exit_menu.sh'"
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p "/commands/custom/<Super>w" -s "exo-open --launch WebBrowser"
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p "/commands/custom/<Super>t" -s "exo-open --launch TerminalEmulator"
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p "/xfwm4/custom/<Super>q" -s "close_window_key"
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p "/xfwm4/custom/<Super>d" -s "show_desktop_key"    
