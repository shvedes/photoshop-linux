#!/usr/bin/env bash

# Adapted script from LinSoftWin/Photoshop-CC2022-Linux

export WINEPREFIX="$1"
export XDG_DATA_HOME="$HOME/.local/share"

LOG_NORMAL="\e[1;97m"
LOG_ERROR="\e[1;31m"
LOG_SUCCESS="\e[1;32m"
LOG_RESET="\e[0m"

TEMP_DIR="$(mktemp -d)"
FILENAME="Photoshop.tar.xz"

trap 'on_error ${LINENO} "$BASH_COMMAND"' ERR
trap on_interrupt SIGINT

on_interrupt() {
	echo -e "\n${LOG_NORMAL}User intrrupt! Cleaning up..${LOG_RESET}"

	if [ -f "./$FILENAME" ]; then
		rm "$FILENAME"
	elif [ -d "./Adobe Photoshop 2021" ]; then
		rm -rf "./Adobe Photoshop 2021"
	fi

	[ -d "$WINEPREFIX" ] && rm -rf "$WINEPREFIX"
	rm -rf "$TEMP_DIR"
	exit 0
}

on_error() {
    local lineno="$1"
    local command="$2"
    echo -e "${LOG_ERROR}[LOG] error in the line ${lineno}${LOG_RESET}: command '$command'"
    exit 1
}

check_dependencies() {
    declare -A packages=(
        ["curl"]="curl"
        ["wine"]="wine"
        ["winetricks"]="winetricks"
        ["magick"]="imagemagick"
    )

    local missed_packages=()

    for bin in "${!packages[@]}"; do
        if ! command -v "$bin" > /dev/null; then
            missed_packages+=("${packages[$bin]}")
        fi
    done

    if [ ${#missed_packages[@]} -eq 0 ]; then
        echo -e "${LOG_SUCCESS}[LOG] All dependencies are installed${LOG_RESET}" && sleep 1
    else
        echo -e "${LOG_ERROR}Missing dependencies:${LOG_NORMAL} ${missed_packages[@]}${LOG_RESET}"
        exit 1
    fi
}

setup_wine() {

	mkdir "$WINEPREFIX"

	echo -e "${LOG_NORMAL}[LOG] Folder $WINEPREFIX created${LOG_RESET}"
	echo -e "${LOG_NORMAL}[LOG] Initializing wine and setting up winetricks.. It may take some time${LOG_RESET}"

	wineboot &> /dev/null
	winetricks fontsmooth=rgb win10 gdiplus msxml3 msxml6 atmlib corefonts dxvk win10 vkd3d d3d12 vkd3d &> /dev/null

	echo -e "${LOG_NORMAL}[LOG] Downloading Visual C++ runtime...${LOG_RESET}"

	# 2015-2022 x64
	curl -s "https://aka.ms/vs/17/release/vc_redist.x64.exe" -o "${TEMP_DIR}/vc_redist_2015_2022_x64.exe"
	echo -e "	${LOG_SUCCESS}Downloaded vc_redist_2015_2022_x64.exe${LOG_RESET}"

	# 2015-2022 x86
	curl -s "https://aka.ms/vs/17/release/vc_redist.x86.exe" -o "${TEMP_DIR}/vc_redist_2015_2022_x86.exe"
	echo -e "	${LOG_SUCCESS}Downloaded vc_redist_2015_2022_x86.exe${LOG_RESET}"

	# 2013 x64
	curl -sL "https://aka.ms/highdpimfc2013x64enu" -o "${TEMP_DIR}/vc_redist_2013_x64.exe"
	echo -e "	${LOG_SUCCESS}Downloaded vc_redist_2013_x64.exe${LOG_RESET}"

	# 2013 x86
	curl -sL "https://aka.ms/highdpimfc2013x86enu" -o "${TEMP_DIR}/vc_redist_2013_x86.exe"
	echo -e "	${LOG_SUCCESS}Downloaded vc_redist_2013_x86.exe${LOG_RESET}"

	# 2012 x64
	curl -s "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe" -o "${TEMP_DIR}/vc_redist_2012_x64.exe"
	echo -e "	${LOG_SUCCESS}Downloaded vc_redist_2012_x64.exe${LOG_RESET}"

	# 2012 x86
	curl -s "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" -o "${TEMP_DIR}/vc_redist_2012_x86.exe"
	echo -e "	${LOG_SUCCESS}Downloaded vc_redist_2012_x86.exe${LOG_RESET}"

	# 2010 x64
	curl -s "https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x64.exe" -o "${TEMP_DIR}/vc_redist_2010_x64.exe"
	echo -e "	${LOG_SUCCESS}Downloaded vc_redist_2010_x64.exe${LOG_RESET}"
	# 2010 x86
	curl -s "https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x86.exe" -o "${TEMP_DIR}/vc_redist_2010_x86.exe"
	echo -e "	${LOG_SUCCESS}Downloaded vc_redist_2010_x86.exe${LOG_RESET}"

	echo -e "${LOG_NORMAL}[LOG] Installing Visual C++...${LOG_RESET}"

	# 2015-2022 x64
	wine "${TEMP_DIR}/vc_redist_2015_2022_x64.exe" /install /quiet /norestart &> /dev/null
	echo -e "	${LOG_SUCCESS}Installed vc_redist_2015_2022_x64.exe${LOG_RESET}"

	# 2015-2022 x86
	wine "${TEMP_DIR}/vc_redist_2015_2022_x86.exe" /install /quiet /norestart &> /dev/null
	echo -e "	${LOG_SUCCESS}Installed vc_redist_2015_2022_x86.exe${LOG_RESET}"

	# 2013 x64
	wine "${TEMP_DIR}/vc_redist_2013_x64.exe" /install /quiet /norestart &> /dev/null
	echo -e "	${LOG_SUCCESS}Installed vc_redist_2013_x64.exe${LOG_RESET}"

	# 2013 x86
	wine "${TEMP_DIR}/vc_redist_2013_x86.exe" /install /quiet /norestart &> /dev/null
	echo -e "	${LOG_SUCCESS}Installed vc_redist_2013_x86.exe${LOG_RESET}"

	# 2012 x64
	wine "${TEMP_DIR}/vc_redist_2012_x64.exe" /install /quiet /norestart &> /dev/null
	echo -e "	${LOG_SUCCESS}Installed vc_redist_2012_x64.exe${LOG_RESET}"

	# 2012 x86
	wine "${TEMP_DIR}/vc_redist_2012_x86.exe" /install /quiet /norestart &> /dev/null
	echo -e "	${LOG_SUCCESS}Installed vc_redist_2012_x86.exe${LOG_RESET}"
	
	# 2010 x64
	wine "${TEMP_DIR}/vc_redist_2010_x64.exe" /q /norestart &> /dev/null
	echo -e "	${LOG_SUCCESS}Installed vc_redist_2010_x64.exe${LOG_RESET}"

	# 2010 x86
	wine "${TEMP_DIR}/vc_redist_2010_x86.exe" /q /norestart &> /dev/null
	echo -e "	${LOG_SUCCESS}Installed vc_redist_2010_x86.exe${LOG_RESET}"

	winecfg -v win10 &> /dev/null
}

download_ps() {
	local url="https://spyderrock.com/kMnq2220-AdobePhotoshop2021.xz"
	# https://github.com/LinSoftWin/Photoshop-CC2022-Linux
	local checksum="8321b969161f2d2ad736067320d493c5b6ae579eaab9400cd1fda6871af2c033"
	
	if [ -f "./$FILENAME" ]; then
		echo -e "${LOG_NORMAL}[LOG] Found existing archive. Comparing checksums${LOG_RESET}"
		local actual_checksum="$(sha256sum $FILENAME | awk '{print $1}')"

		if [ "$actual_checksum" != "$checksum" ]; then
			echo -e "${LOG_ERROR}[LOG] Corrupted archive!${LOG_NORMAL} Redownloading (1.1G)${LOG_RESET}"
			rm "./$FILENAME"
			curl -s "$url" -o "$FILENAME"
		else
			echo -e "${LOG_SUCCESS}[LOG] Done${LOG_SUCCESS}"
		fi
	else
		echo -e "${LOG_NORMAL}[LOG] Downloading Photoshop (1.1G)${LOG_RESET}"
		curl -s "$url" -o "$FILENAME"
		echo -e "${LOG_SUCCESS}[LOG] Downloaded Photoshop${LOG_RESET}"

		actual_checksum="$(sha256sum $FILENAME | awk '{print $1}')"
		echo -e "${LOG_NORMAL}[LOG] Verifying checksums${LOG_RESET}"

		if [[ "$actual_checksum" != "$checksum" ]]; then
			echo -e "${LOG_ERROR}[ERROR] Checksums are not matched!${LOG_NORMAL} Try to remove '$FILENAME' and exec this script again${LOG_RESET}"
			exit 1
		else
			echo -e "${LOG_SUCCESS}[LOG] Done${LOG_RESET}"
		fi
	fi
}

install_ps() {
	echo -e "${LOG_NORMAL}[LOG] Extracting Photoshop${LOG_RESET}"
	tar -xf "./$FILENAME"
	
	echo -e "${LOG_NORMAL}[LOG] Installing Photoshop${LOG_RESET}"
	mv "Adobe Photoshop 2021" "$WINEPREFIX/drive_c/Program Files/Adobe Photoshop 2021"
}

install_icon() {
	if [ -d "/usr/share/icons/Papirus" ]; then
		DESKTOP_ENTRY_ICON_NAME="photoshop"
	elif [ -d "$XDG_DATA_HOME/icons/Papirus" ]; then
		DESKTOP_ENTRY_ICON_NAME="photoshop"
	else
		DESKTOP_ENTRY_ICON_NAME="$XDG_DATA_HOME/icons/photoshop.png"
		ICON_URL="https://cdn3d.iconscout.com/3d/premium/thumb/adobe-photoshop-file-3d-icon-download-in-png-blend-fbx-gltf-formats--logo-format-graphic-design-pack-development-icons-9831950.png"
		curl -s "$ICON_URL" -o "${TEMP_DIR}/icon.webp"
		magick "${TEMP_DIR}/icon.webp" "${TEMP_DIR}/icon.png"

		[ ! -d "$XDG_DATA_HOME/icons" ] && mkdir "$XDG_DATA_HOME/icons"
		mv ${TEMP_DIR}/icon.png "$XDG_DATA_HOME/icons/photoshop.png"
	fi
}

install_desktop_entry() {
	local path="$XDG_DATA_HOME/applications/photoshop.desktop"
	
	echo "[Desktop Entry]"																					>  "$path"
	echo "Name=Adobe Photoshop CC 2021"																		>> "$path"
	echo "Exec=bash -c "$WINEPREFIX/drive_c/launcher.sh %F""												>> "$path"
	echo "Type=Application"																					>> "$path"
	echo "Comment=The industry-standard photo editing software (Wine)"										>> "$path"
	echo "Categories=Graphics"																				>> "$path"
	echo "Icon=$DESKTOP_ENTRY_ICON_NAME"																	>> "$path"
	echo "MimeType=image/psd;image/x-psd;image/png;image/jpg;image/jpeg;image/webp;image/heif;image/raw"	>> "$path"
	echo "StartupWMClass=photoshop.exe"																		>> "$path"
}

install_launcher() {
	echo -e "${LOG_NORMAL}[LOG] Installing launcher${LOG_RESET}"

	local path="$WINEPREFIX/drive_c/launcher.sh"

	echo "#!/usr/bin/env bash"																								>  "$path"
	echo " "																												>> "$path"
	echo "WINEPREFIX=\"$WINEPREFIX\""																						>> "$path"
	echo "DXVK_LOG_PATH=\"\$WINEPREFIX/dxvk_cache\""																		>> "$path"
	echo "DXVK_STATE_CACHE_PATH=\"\$WINEPREFIX/dxvk_cache\""																>> "$path"
	echo "PHOTOSHOP=\"\$WINEPREFIX/drive_c/Program Files/Adobe Photoshop 2021/photoshop.exe\""								>> "$path"
	echo " "																												>> "$path"
	echo "wine64 \"\$PHOTOSHOP\" \"\$@\" "																					>> "$path"

	chmod +x "$path"
}

checks() {
	if [ -z "$1" ]; then
		echo -e "${LOG_NORMAL}Usage: ./install.sh <absolute path>${LOG_RESET}"
		exit 0
	else
		if [ -d "$1" ]; then
			echo -e "${LOG_ERROR}Install path alrady exists${LOG_RESET}"
			read -p "$(tput setaf 3)Do you want to remove it? (y/n) $(tput sgr0)" answer

			case "$answer" in
				y)
					rm -rf "$WINEPREFIX"
					;;
				n)
					exit 1
					;;
			esac
		else
			if [[ "$1" != /* ]]; then
				echo -e "${LOG_NORMAL}You need to specify absolute path, not relative${LOG_RESET}"
				exit 1
			fi
		fi
	fi
}

checks "$1"
check_dependencies
setup_wine
download_ps
install_ps
install_icon
install_desktop_entry
install_launcher

echo -e "${LOG_SUCCESS}[LOG] Photoshop successfully installed${LOG_RESET}"
