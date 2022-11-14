#!/usr/bin/env bash

# PKGS

PKGS=()
while read -r pkg; do
  PKGS+=("$pkg" "")
done < setup/packages

# FUNCTIONS

menu () {
    CHOICES=$(whiptail --title "Archmage" --menu "" --default-item "$1" 18 50 10 \
    1 "Install yay (if not installed)" \
    2 "Update system" \
    3 "Setup DE" \
    4 "Install software" \
    5 "Remove software" \
    6 "Automatic setup" 3>&1 1>&2 2>&3)

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
        setup_DE
        ;;
        4)
        install_packages
        ;;
        5)
        remove_packages        
        ;;
        6)
        AUTOMATIC=true
        install_yay
        setup_DE
        update_system 
        install_packages
        remove_packages
        if whiptail --yesno "Finished! Do you wish to reboot now?" 10 50; then
            reboot
            else
            AUTOMATIC=false
            menu 6
        fi
        ;;
        esac
    done
    fi
}

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

setup_DE () {
    CHOICES=$(whiptail --title "Desktop environment" --menu "" --default-item "$1" 18 50 10 \
    1 "Xfce" 3>&1 1>&2 2>&3)

    if [ -z $CHOICES ]; then
    echo "Ok"
    else
    for CHOICE in $CHOICES; do
        case "$CHOICE" in
        1)
        sh setup/setup_xfce.sh
        ;;
        esac
    done
    fi
    menu 4
}

install_packages () {
    SELECTION_INSTALL=( $(whiptail --title "Install software" --separate-output --checklist --noitem "Select packages:" 24 80 14 "${PKGS[@]}" 3>&1 1>&2 2>&3) )
    for PKG in ${SELECTION_INSTALL[@]}; do
        yay -S --needed --noconfirm $PKG
    done
    if ! $AUTOMATIC; then menu 5; fi
}

remove_packages () {
    INSTALLED_PACKAGES=$(pacman -Qe | awk '{print $1}')
    IP=()
    for PKG in ${INSTALLED_PACKAGES[@]}; do
        IP+=("$PKG" "" "")
    done
    SELECTION_INSTALL=( $(whiptail --title "Remove software" --separate-output --checklist "Select packages:" 24 80 14 "${IP[@]}" 3>&1 1>&2 2>&3) )
    for PKG in ${SELECTION_INSTALL[@]}; do
        yay -R --noconfirm $PKG
    done
    if ! $AUTOMATIC; then menu 5; fi
}

# RUN

ARCHMAGEDIR=$(pwd)
# install libnewt for whiptail if not installed
sudo pacman -S --needed libnewt
# run automatically
AUTOMATIC=false
# archmage menu
menu 6
echo
echo "Done! Reboot if necessary."
echo