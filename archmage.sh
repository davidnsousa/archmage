#!/usr/bin/env bash

# PKGS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

PKGS=()
while IFS=, read -r pkg desc tag; do
  PKGS+=("$pkg" "$desc" "$tag")
done < packages

# FUNC >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

menu () {
    CHOICES=$(whiptail --title "Archmage" --menu "" --default-item "$1" 18 50 10 \
    1 "Install yay (if not installed)" \
    2 "Update system" \
    3 "Install software" \
    4 "Remove software" \
    5 "Setup DE" \
    6 "All" 3>&1 1>&2 2>&3)

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
        remove_packages
        ;;
        5)
        setup_DE
        ;;
        6)
        AUTOMATIC=true
        install_yay
        update_system 
        install_packages
        remove_packages
        setup_DE
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
    SELECTION_INSTALL=( $(whiptail --title "Install software" --separate-output --checklist "Select packages:" 24 80 14 "${PKGS[@]}" 3>&1 1>&2 2>&3) )
    for PKG in ${SELECTION_INSTALL[@]}; do
        yay -S --noconfirm $PKG
    done
    if ! $AUTOMATIC; then menu 4; fi
}

remove_packages () {
    SELECTION_REMOVE=$(pacman -Qe | awk '{print $1}')
    SR=()
    for PKG in ${SELECTION_REMOVE[@]}; do
        yay -R --noconfirm $PKG
    done
    if ! $AUTOMATIC; then menu 5; fi
}

# DESKTOP ENVIRONMENT SETUP

setup_DE () {
    sh setupDE.sh
    menu 5
}

# RUN >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

ARCHMAGEDIR=$(pwd)

AUTOMATIC=false

menu 6

echo
echo "Done! Reboot if necessary."
echo