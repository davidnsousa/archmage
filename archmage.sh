#!/usr/bin/env bash

# PKGS

PKGS=()
while read -r pkg; do
  PKGS+=("$pkg" "")
done < setup/packages

# FUNCTIONS

menu () {
    CHOICES=$(whiptail --ok-button "Run" --cancel-button "Leave" --title "Archmage" --menu "\n" --default-item "$1" 18 50 10 \
    1 "Install yay" \
    2 "Update system" \
    3 "Setup DE" \
    4 "Install software" \
    5 "Remove software" \
    6 "Run all" \
    7 "Reboot" 3>&1 1>&2 2>&3)

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
            menu 7
        fi
        ;;
        7)
        reboot
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
    1 "Xfce" \
    2 "Openbox based" 3>&1 1>&2 2>&3)

    if [ -z $CHOICES ]; then
    echo "Ok"
    else
    for CHOICE in $CHOICES; do
        case "$CHOICE" in
        1)
        sh setup/xfce.sh
        ;;
        2)
        sh setup/openbox.sh
        ;;
        esac
    done
    fi
    echo
    echo "Change hostname to archmage:"
    echo
    sudo hostnamectl set-hostname archmage 
    if ! $AUTOMATIC; then menu 4; fi
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
    if ! $AUTOMATIC; then menu 7; fi
}

# RUN

# working dir
ARCHMAGEDIR=$(pwd)
# install libnewt for whiptail if not installed
echo
echo "Install libnewt for archmage whiptail menu::"
echo
sudo pacman -S --needed libnewt
# run automatically
AUTOMATIC=false
# archmage menu
menu 6
