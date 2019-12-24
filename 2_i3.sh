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
ExecStart=-/usr/bin/agetty --autologin $USER --noclear %I $TERM
END

echo "Installing xorg and dependencies"
sudo pacman -S --noconfirm xorg xf86-input-libinput xorg-xinput xorg-xinit xterm

echo "Installing Termite terminal"
sudo pacman -S --noconfirm termite

echo "Ricing Termite"
mkdir -p ~/.config/termite
wget -P ~/.config/termite https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/termite/config.monochrome
mv ~/.config/termite/config.monochrome ~/.config/termite/config
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

echo "Autostart i3 at login"
touch ~/.xinitrc
tee -a ~/.xinitrc << END
#! /bin/bash
exec i3
END

echo "Ricing i3"
mkdir -p ~/.config/i3
wget -P ~/.config/i3 https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/i3/config

echo "Installing i3blocks"
sudo pacman -S --noconfirm i3blocks

echo "Ricing i3blocks"
mkdir -p ~/.config/i3blocks
wget -P ~/.config/i3blocks https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/i3blocks/config

echo "Installing i3 dependencies"
sudo pacman -S --noconfirm pulseaudio pavucontrol thunar mousepad qalculate-gtk rofi feh

echo "Ricing rofi"
mkdir -p ~/.config/rofi
wget -P ~/.config/rofi https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/rofi/monochromatic.rasi
mv ~/.config/rofi/monochromatic.rasi ~/.config/rofi/config.rasi

echo "Installing and configuring i3lock"
sudo pacman -S --noconfirm imagemagick feh xorg-xrandr xorg-xdpyinfo
yay -S --noconfirm i3lock-color betterlockscreen
sudo cp /usr/share/doc/betterlockscreen/examples/betterlockscreenrc ~/.config

echo "Enabling auto-mount and archives creation/deflation for thunar"
sudo pacman -S --noconfirm gvfs thunar-volman thunar-archive-plugin ark file-roller xarchiver

echo "Installing GTK theme and dependencies"
sudo pacman -S --noconfirm gtk-engine-murrine gtk-engines
sudo mkdir -p /usr/share/themes/
sudo wget -P /usr/share/themes/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/themes/Qogir-win-light.tar.gz
sudo tar -xzf /usr/share/themes/Qogir-win-light.tar.gz -C /usr/share/themes/
sudo rm -f /usr/share/themes/Qogir-win-light.tar.gz

echo "Installing icons"
sudo pacman -S --noconfirm papirus-icon-theme
git clone https://aur.archlinux.org/papirus-folders-git.git
cd papirus-folders-git
yes | makepkg -si
cd ..
rm -rf papirus-folders-git
papirus-folders -C black --theme Papirus-Dark

echo "Setting GTK theme, font and icons"
FONT="RobotoMono Nerd Font Regular 9"
GTK_THEME="Qogir-win-light"
GTK_ICON_THEME="Papirus-Dark"
GTK_SCHEMA="org.gnome.desktop.interface"
gsettings set $GTK_SCHEMA gtk-theme "$GTK_THEME"
gsettings set $GTK_SCHEMA icon-theme "$GTK_ICON_THEME"
gsettings set $GTK_SCHEMA font-name "$FONT"
gsettings set $GTK_SCHEMA document-font-name "$FONT"

echo "Installing office applications"
sudo pacman -S --noconfirm tumbler evince thunderbird

echo "Adding VSCode theme"
code --install-extension gtwsky.oolory

echo "Improving fonts rendering"
mkdir -p ~/.config/fontconfig
sudo wget -P ~/.config/fontconfig https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/fonts/fonts.conf

echo "Autostart X with fish"
tee -a ~/.config/fish/config.fish << END
# Start X at login
if status is-interactive
    if test -z "$DISPLAY" -a $XDG_VTNR = 1
        exec startx -- -keeptty
    end
end
END

echo "Your setup is ready. You can reboot now!"