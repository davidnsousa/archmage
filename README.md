# Archmage - Arch Linux Post Installation Setup

Archmage is a simple post-install shell script to choose easily from a variety of packages for development, productivity, communication, etc, from both the official Arch repositeries and AUR using the Pacman wrapper and AUR helper yay. 

I wrote the script according to my software needs and XFCE (and other) preferences (theming, keyboard shortcuts, utilities, etc) to help me replicate or reset my Arch system whenever I need. 

Fork it and change it according to your needs.

### Usage

```
git clone https://github.com/davidnsousa/archmage
cd archmage
sh archmage.sh
```

`archmage.sh' will ask to (1) install yay (if not installed), (2) update the system, (3) choose from a preselection of packages to install and (4) costumize XFCE with a preselection of packages and settings.