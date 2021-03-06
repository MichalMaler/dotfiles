#!/bin/bash

USER_NAME=`who | awk '{print $1}'`
HOME=/home/$USER_NAME

# basic packages
  dnf -y check-update
  dnf -y upgrade
  dnf -y install \
    neovim ctags tig hub \
    gcc gcc-c++ cmake make \
    tar unzip p7zip ncompress \
    htop alsa-utils alsa-lib sudo curl wget tmux \
    mesa-vdpau-drivers brightnessctl redshift i3 i3status i3lock rxvt-unicode-256color \
    network-manager-applet \
    ruby gem openssl-devel readline-devel zlib-devel \
    fuse fuse-ntfs-3g dkms gparted \
    kernel-modules-extra
  # rpmfusion repo (vlc, steam)
  dnf -y install dnf-plugins-core
  dnf -y install --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                              http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
  dnf -y install vlc
  # copr repo (telegram, xrectsel)
  dnf -y copr enable heliocastro/hack-fonts
  dnf -y copr enable rommon/telegram
  dnf -y copr enable stbenjam/xrectsel
  dnf -y copr enable carlwgeorge/ripgrep
  dnf -y install xrectsel byzanz telegram-desktop hack-fonts
  # negativo17 repo (spotify)
  dnf -y config-manager --add-repo=http://negativo17.org/repos/fedora-spotify.repo
  dnf -y install spotify-client
  dnf -y install steam
  dnf -y ripgrep

# rbenv
  git clone https://github.com/sstephenson/rbenv.git .rbenv
  git clone https://github.com/sstephenson/ruby-build.git .rbenv/plugins/ruby-build

# fzf
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  $HOME/.fzf/install

# dotfiles
  rm .ssh -r
  ruby install.rb

# git-prompt and completion
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o .git-prompt.sh
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o .git-completion.bash
  chmod +x .git-prompt.sh
  chmod +x .git-completion.bash

# neobundle
  curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh
  nvim +NeoBundleInstall +qall

rm -r Desktop Documents Music Pictures Public Templates Videos
mkdir tmp devel

chown $USER_NAME:$USER_NAME -R etc tmp devel .*
chmod 600 .ssh/config

git config --global core.excludesfile .gitignore
git config --global core.editor nvim

exit 0
