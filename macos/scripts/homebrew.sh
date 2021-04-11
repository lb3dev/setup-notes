## Install brew if not found

if test ! $(which brew); then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

## Disable analytics

brew analytics off

## Update Homebrew

brew update

## Upgrade all existing packages

brew upgrade

## Essentials

brew install python

## Backup related

brew install rdiff-backup
brew install rclone
brew install rsync

## Cask Packages

brew install --cask android-file-transfer
brew install --cask google-chrome
brew install --cask firefox
brew install --cask keepassxc
brew install --cask sublime-text
brew install --cask visual-studio-code
brew install --cask pycharm-ce

## Clean up

brew cleanup