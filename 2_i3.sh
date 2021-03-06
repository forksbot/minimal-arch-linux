#!/bin/bash

echo "Downloading and running base script"
wget https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/2_base.sh
chmod +x 2_base.sh
sh ./2_base.sh

echo "Enabling autologin"
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
sudo touch /etc/systemd/system/getty@tty1.service.d/override.conf
sudo tee -a /etc/systemd/system/getty@tty1.service.d/override.conf << END
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --skip-login --nonewline --noissue --autologin $USER --noclear %I $TERM
END

echo "Removing last login message"
touch ~/.hushlogin

echo "Installing xorg and dependencies"
sudo pacman -S --noconfirm xorg xf86-input-libinput xorg-xinput xorg-xinit xterm

echo "Installing Termite terminal"
sudo pacman -S --noconfirm termite

echo "Ricing Termite"
mkdir -p ~/.config/termite
wget -P ~/.config/termite https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/termite/config.shapeshifter
mv ~/.config/termite/config.shapeshifter ~/.config/termite/config
mkdir -p ~/.config/gtk-3.0
touch ~/.config/gtk-3.0/gtk.css
tee -a ~/.config/gtk-3.0/gtk.css << END
VteTerminal, vte-terminal {
 padding: 18px;
}
END

echo "Installing Picom (former compton)"
sudo pacman -S --noconfirm picom

echo "Ricing Picom"
mkdir -p ~/.config/picom
wget -P ~/.config/picom https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/picom/picom.conf

echo "Installing i3"
sudo pacman -S --noconfirm i3-gaps

echo "Making i3 start on login"
wget -P ~/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/zsh/.zprofile.i3
mv .zprofile.i3 .zprofile

echo "Ricing i3"
mkdir -p ~/.config/i3
wget -P ~/.config/i3 https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/i3/config

echo "Installing i3blocks"
sudo pacman -S --noconfirm i3blocks

echo "Ricing i3blocks"
mkdir -p ~/.config/i3blocks
wget -P ~/.config/i3blocks https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/i3blocks/config

echo "Installing i3 dependencies"
sudo pacman -S --noconfirm pulseaudio pavucontrol thunar mousepad qalculate-gtk feh i3lock

echo "Enabling auto-mount and archives creation/deflation for thunar"
sudo pacman -S --noconfirm gvfs thunar-volman thunar-archive-plugin ark file-roller xarchiver

echo "Installing office applications"
sudo pacman -S --noconfirm tumbler evince thunderbird

echo "Installing and ricing rofi"
sudo pacman -S --noconfirm rofi
mkdir -p ~/.config/rofi
wget -P ~/.config/rofi https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/rofi/config.rasi
wget -P ~/.config/rofi https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/rofi/monochromatic.rasi
mv ~/.config/rofi/monochromatic.rasi ~/.config/rofi/config.rasi

echo "Installing GTK theme and dependencies"
sudo pacman -S --noconfirm gtk-engine-murrine gtk-engines
sudo mkdir -p /usr/share/themes/
sudo wget -P /usr/share/themes/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/themes/Qogir-win-light.tar.gz
sudo tar -xzf /usr/share/themes/Qogir-win-light.tar.gz -C /usr/share/themes/
sudo rm -f /usr/share/themes/Qogir-win-light.tar.gz

echo "Installing Tela icons"
sudo mkdir -p /usr/share/icons/
sudo wget -P /usr/share/icons/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/themes/tela-icons.tar.gz
sudo tar -xzf /usr/share/icons/tela-icons.tar.gz -C /usr/share/icons/
sudo rm -f /usr/share/icons/tela-icons.tar.gz

echo "Installing Quintom Snow cursor"
sudo wget -P /usr/share/icons/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/themes/Quintom_Snow.tar.gz
sudo tar -xzf /usr/share/icons/Quintom_Snow.tar.gz -C /usr/share/icons/
sudo rm -f /usr/share/icons/Quintom_Snow.tar.gz

echo "Installing San Francisco Fonts"
git clone https://aur.archlinux.org/otf-san-francisco-pro.git
cd otf-san-francisco-pro
makepkg -si --noconfirm
cd ..
rm -rf otf-san-francisco-pro

echo "Setting GTK theme, font and icons"
mkdir -p ~/.config/gtk-3.0
touch ~/.config/gtk-3.0/settings.ini
tee -a ~/.config/gtk-3.0/settings.ini << END
[Settings]
gtk-theme-name=Qogir-win-light
gtk-icon-theme-name=Tela-black
gtk-font-name=San Francisco Pro Regular 10
gtk-cursor-theme-name=Quintom_Snow
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
END

echo "Enabling suspend and hibernate hotkeys"
sudo sed -i 's/#HandlePowerKey=poweroff/HandlePowerKey=hibernate/g' /etc/systemd/logind.conf
sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=suspend/g' /etc/systemd/logind.conf

echo "Adding VSCode theme"
code --install-extension viktorqvarfordt.vscode-pitch-black-theme

echo "Applying VSCode user settings"
mkdir -p ~/.config/Code\ -\ OSS/User
wget -P ~/.config/Code\ -\ OSS/User https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/
vscode/settings.json

echo "Your setup is ready. You can reboot now!"
