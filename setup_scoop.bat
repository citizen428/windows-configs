@ECHO OFF
TITLE Setting up Scoop
ECHO ================
ECHO Installing Scoop
ECHO ================
CALL powershell -C "iwr -useb get.scoop.sh | iex"
ECHO ==============
ECHO Adding buckets
ECHO ==============
CALL scoop install 7zip git
CALL scoop bucket add extras
CALL scoop bucket add nerd-fonts
CALL scoop bucket add versions
ECHO ===================
ECHO Installing packages
ECHO ===================
CALL scoop install^
 7zip^
 aria2^
 delta^
 git^
 greenshot^
 insomnia^
 lab^
 neovim-nightly^
 qbittorrent^
 signal^
 slack^
 starship^
 sysinternals^
 telegram^
 wiztree^
 wslgit^
 z^
 zeal
ECHO ================
ECHO Installing fonts
ECHO ================
CALL scoop install sudo
CALL sudo scoop install FiraCode-NF
ECHO =======
ECHO Summary
ECHO =======
CALL scoop list
