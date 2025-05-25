# Adobe Photoshop CC 2021 on Linux

## Disclaimer

By providing this software, I do not give any guarantees of its work. This script was inspired by the work of [LinSoftWin](https://github.com/LinSoftWin/Photoshop-CC2022-Linux). This is only its adaptation. This script will be maintained and developed until I get bored and/or have free time. PR is welcome.

Please note that this code is a piece of garbage. Although it works in most cases, I do not guarantee that it will work completely. Please read the source before using it.

## Showcase 

![install](https://github.com/user-attachments/assets/3a4fb514-360e-4e10-a7a6-793d70b7ca91)
![delete](https://github.com/user-attachments/assets/0308a1e3-8e9d-4fb0-b7f1-409d7e961891)

### What works

- Drag and drop ~~(doesn't work on Hyprland)~~ (should be fixed with recent update. Not tested)
- Clipboard image pasting
- Mime type association (right click menu, see [here](https://github.com/user-attachments/assets/eb5f7ab3-fb75-47e7-841b-a763ca5e3382))
- GPU acceleration (no warranty to work)

**Tested on:**
- Arch Linux / CachyOS / NixOS / Linux Mint
- KDE Plasma 6.2 (Wayland) / Hyprland
- wine 9.19+ / wine-staging 9.20+ / ~~wine-cachyos 9.20+~~ window freezes
- AMD GPU

### Known issues

- When hovering on toolbar item to see its instructions, black bars may appear around
- Wine's experimental wayland driver is completely broken

### Notes

- If you have **Papirus Icons** installed, the script will use an icon that is already in that pack. If not, the script will download an icon from the internet and use it for the `.desktop` entry.

## Usage

```bash
./photoshop.sh
Usage: ./install.sh [options...] <path>
  -a                Use already existing Photoshop.tar.xz
  -i                Install Photoshop
  -u <install path> Uninstall Photoshop
  -h                Show this help
```
## Support

Just follow me on GitHub :)
