#!/usr/bin/env bash

# vim: set tabstop=2 shiftwidth=2 expandtab:

# This work and script was adapted by the work of user LinSoftWin. If it wasn't for him - it wouldn't have happened.
# This script downloads a PIRATE version of Photoshop, because it is not possible to run the actual version from Adobe Creative Cloud.
# Use it at your own risk. The license applies only to the files in this repository.
# I am not responsible for any other files downloaded from other links using the script.
# If the link becomes inactive - it will be replaced by another hosting. Checksums of uploaded files will also be updated.

# In case the user does not use the XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/latest
XDG_DATA_HOME="$HOME/.local/share"

# TODO: refactoring

if [ ! -d "$XDG_CACHE_HOME" ]; then
  XDG_CACHE_HOME="$HOME/.cache"
fi

BLUE="\e[1;34m"   # Blue
RED="\e[1;31m"    # Red
YELLOW="\e[1;33m" # Yellow
GREEN="\e[1;32m"  # Green
RESET="\e[0m"     # Reset colors

LOG="${BLUE}[LOG]${RESET}"
WARNING="${YELLOW}[WARNING]${RESET}"
ERORR="${RED}[ERROR]${RESET}"
SUCCES="${GREEN}[SUCCES]${RESET}"
CHECK="${GREEN}[CHECK]${RESET}"

INSTALL_PATH="$HOME/.photoshop"
CACHE_FOLDER="$XDG_CACHE_HOME/photoshop-linux"

PHOTOSHOP_URL="https://spyderrock.com/kMnq2220-AdobePhotoshop2021.xz"
CHECKSUM="8321b969161f2d2ad736067320d493c5b6ae579eaab9400cd1fda6871af2c033"

# Imagemagick is needed in case you are not using Papirus Icons.
# One of the functions will load a Photoshop `.webp` icon and convert it to `.png`. The `.png` file will be used in the `.desktop` entry.
check_deps() {
  declare -A packages=(
    ["winetricks"]="winetricks"
    ["magick"]="imagemagick"
    ["wine"]="wine"
  )

  missed_packages=()

  for bin in "${!packages[@]}"; do
    if ! command -v "$bin" >/dev/null; then
      missed_packages+=("${packages[$bin]}")
    fi
  done

  if [ ${#missed_packages[@]} -eq 0 ]; then
    echo -e "$CHECK All dependencies are installed."
  else
    echo -e "$WARNING Missing dependencies: ${YELLOW}${missed_packages[*]}${RESET}."
    return 1
  fi
}

install_proton() {
  local proton_url="https://archive.cachyos.org/proton/proton-cachyos-1%3A9.0.20240928-1-x86_64_v3.pkg.tar.zst"
  local proton_signature_url="https://archive.cachyos.org/proton/proton-cachyos-1%3A9.0.20240928-1-x86_64_v3.pkg.tar.zst.sig"

  echo -e "$LOG Recieving CachyOS GPG key"
  if ! gpg --keyserver hkps://keys.openpgp.org --recv-key F3B607488DB35A47 &> /dev/null; then
    echo -e "$ERORR Something went wrong"
    exit 1
  fi
  
  echo -e "$LOG Downloading proton"
  curl --progress-bar "$proton_url" -o "${CACHE_FOLDER}/proton-cachyos.tar.zst"
  curl --progress-bar "$proton_signature_url" -o "${CACHE_FOLDER}/proton-cachyos.sig"

  echo -e "$LOG Validating checksums"
  if ! gpg --verify "${CACHE_FOLDER}/proton-cachyos.sig" "${CACHE_FOLDER}/proton-cachyos.tar.zst" &> /dev/null; then
    echo -e "$ERORR Invalid signature"
    exit 1
  fi

  echo -e "$LOG Signature is valid" && echo -e "$LOG Installing proton"
  tar xf "$CACHE_FOLDER/proton-cachyos.tar.zst" -C "${INSTALL_PATH}/proton"
  echo -e "$LOG Proton installed"
}

download_photoshop() {
  local archive_name="Photoshop.tar.xz"

  if [ -f "./${archive_name}" ]; then
    echo -e "$LOG Found existing archive in current folder."
    echo -e "$LOG Comparing checksums."

    local local_checksum
    local_checksum="$(sha256sum "$archive_name" | awk '{print  $1}')"

    if [[ "$CHECKSUM" != "$local_checksum" ]]; then
      echo -e "$LOG Checksums don't match!"
      echo -e "$LOG Deleting corrupted archive."
      rm -v "${archive_name:?}" &>>./install_log.log
    fi

    return 0
  fi

  echo -e "$LOG Downloading Photoshop (1.1G)."
  if ! curl --progress-bar "$PHOTOSHOP_URL" -o "${CACHE_FOLDER}/${archive_name}"; then
    # TODO:
    # separate function to avoid repeating
    echo -e "$ERROR An error occurred during the download. Please, refer to ${YELLOW}install_log.log${RESET} for more info."
    echo -e "$ERROR If you can't solve the issue yourself, please, open an issue on the GitHub."
    exit 1
  fi

  # TODO:
  # A separate function so you don't have to write this code multiple times
  echo -e "$LOG Comparing checksums."
  local local_checksum
  local_checksum="$(sha256sum "${CACHE_FOLDER}/${archive_name}" | awk '{print  $1}')"

  if [[ "$CHECKSUM" != "$local_checksum" ]]; then
    echo -e "$ERROR Checksums don't match!"
    exit 1

  # TODO
  # 	while true; do
  # 		read -p "$(echo -e "$LOG_WARNING")[WARNING]$(echo -e "$LOG_RESET") Do you want to redownload it again? (yes/no): " answer
  # 		case "$answer" in
  # 			pattern)
  # 				command ...
  # 				;;
  # 			*)
  # 				command ...
  # 				;;
  # 		esac
  # 	done
  fi
}

install_photoshop() {
  if [ -z "$LOCAL_ARCHIVE" ]; then
    # echo -e "${LOG_NORMAL}[LOG]${LOG_RESET} Installing Photoshop."
    local filename="Photoshop.tar.xz"

    echo -e "$LOG Extracting Photoshop."
    if ! tar xvf "${CACHE_FOLDER}/${filename}" -C "$CACHE_FOLDER" &>>./install_log.log; then
      echo -e "$ERORR An error occurred while unpacking the archive."
      exit 1
      # TODO:
      # A separate function so you don't have to write this code multiple times
      # while true; do
      # 	read -p "Delete wine prefix?"
      # 	command ...
      # done
    fi

    echo -e "$LOG Installing Photoshop."
    if ! mv "${CACHE_FOLDER}/Adobe Photoshop 2021"/* "$INSTALL_PATH/photoshop"; then
      echo -e "$ERROR An error occurred during installation."
      exit 1
    fi
  else
    echo -e "$LOG Using given local Photoshop archive."

    if [[ ! "$LOCAL_ARCHIVE" = *.tar.xz ]]; then
      echo -e "$ERORR Only tar.xz is accepted for now."
      exit 1
      # TODO:
      # Allow user to use not only tar.xz / archive from another sources
    fi

    # TODO:
    # A separate function so you don't have to write this code multiple times
    echo -e "$LOG Comparing checksums."

    local local_checksum
    local_checksum="$(sha256sum "$LOCAL_ARCHIVE" | awk '{print  $1}')"

    # TODO:
    # Allow user to skip checksum comparing
    if [[ "$CHECKSUM" != "$local_checksum" ]]; then
      echo -e "$ERROR Checksums don't match!"
      exit 1
    fi

    echo -e "$LOG Extracting Photoshop."
    if ! tar xvf "$LOCAL_ARCHIVE" &>>./install_log.log; then
      echo -e "$ERROR An error occurred while unpacking the archive."
      exit 1
      # TODO:
      # A separate function so you don't have to write this code multiple times
      # while true; do
      # 	read -p "Delete wine prefix?"
      # 	command ...
      # done
    fi

    echo -e "$LOG Installing Photoshop."
    if ! mv "./Adobe Photoshop 2021" "$INSTALL_PATH/drive_c/Program Files"; then
      echo -e "$ERROR An error occurred during installation. Please, refer to ${YELLOW}install_log.log${RESET} for more info."
      echo -e "$ERROR If you can't solve the issue yourself, please, open an issue on the GitHub."
      exit 1
    fi
  fi
}

setup_wine() {
  export WINEPREFIX="${INSTALL_PATH}/prefix"
  local vc_libraries=("vcrun2003" "vcrun2005" "vcrun2010" "vcrun2012" "vcrun2013" "vcrun2022")

  echo -e "$LOG Setting up wine prefix."
  winecfg /v win10 2>/dev/null

  echo -e "$LOG Downloading and installing core components for wine prefix. This could take some time."

  if ! winetricks --unattended corefonts win10 vkd3d dxvk2030 msxml3 msxml6 gdiplus &>./install_log.log; then
    echo -e "$ERORR Winetricks terminated with an error."
    echo -e "$ERROR Please open an issue by mentioning the contents of ${YELLOW}./install_log.log${RESET}."
    exit 1
  fi

  {
    echo "---------------------------------------------------------------------"
    echo "                  Downloading Visual C++ Libraries				   "
    echo "---------------------------------------------------------------------"
  } >>./install_log.log # Thanks to Katy248 for the idea.

  echo -e "$LOG Downloading and installing Visual C++ libraries."
  if ! winetricks --unattended "${vc_libraries[@]}" &>>./install_log.log; then
    echo -e "$ERROR Winetricks terminated with an error. Please, refer to ${YELLOW}install_log.log${RESET} for more info."
    echo -e "$ERROR If you can't solve the issue yourself, please, open an issue on the GitHub."
    exit 1
  fi
}

[[ -d "$CACHE_FOLDER" ]] && rm -r "$CACHE_FOLDER" && rm -r "$INSTALL_PATH"
mkdir -p "$CACHE_FOLDER" "${INSTALL_PATH}/proton" "${INSTALL_PATH}/prefix" "${INSTALL_PATH}/photoshop"

check_deps
install_proton
setup_wine
download_photoshop
install_photoshop
