# Adobe Photoshop CC 2021 on Linux

## Disclaimer

By providing this software, I do not give any guarantees of its work. This script was inspired by the work of [LinSoftWin](https://github.com/LinSoftWin/Photoshop-CC2022-Linux). This is only its adaptation. This script will be maintained and developed until I get bored and/or have free time. PR is welcome.

## Showcase 

![image](https://github.com/user-attachments/assets/5f4edc77-a67e-49c5-8332-b436f1d6134d)
![image](https://github.com/user-attachments/assets/ad8c7477-4682-4edc-8665-4f5b5380a382)

### What works

- Drag and drop
- Clipboard image pasting
- Mime type association (right click menu, see [here](https://github.com/user-attachments/assets/eb5f7ab3-fb75-47e7-841b-a763ca5e3382))
- GPU acceleration

**Tested on:**
- Arch Linux
- KDE Plasma 6.2 (Wayland)
- wine 9.19
- AMD GPU

### Known issues

- When hovering on toolbar item to see its instructions, black bars may appear around
- Wine's experimental wayland driver is completely broken

### Notes

- If you have **Papirus Icons** installed, the script will use an icon that is already in that pack. If not, the script will download an icon from the internet and use it for the `.desktop` entry.

## Usage

```bash
./install.sh
Usage: ./install.sh [options...] <path>
-a    Use already existing Photoshop.tar.xz
-i    Install Photoshop
-h    Show this help
```
## To Do

- [ ] Properly implement logging
- [ ] Multi distro dependencies installer (for now only Arch Linux is supported)
- [ ] Create universal functions for repetitive actions
- [x] Implement colored logging in a different way, making the code more readable
- [ ] Allow the user to use a different source to download Photoshop
    - [ ] Allow the user to skip checksum verification of downloaded files
- [ ] Uninstall script
- [x] More checks in the install script
- [x] Ability for the user to select a default installation folder

## Support

Just follow me on GitHub :)
