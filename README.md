# Adobe Photoshop CC 2021 on Linux

## Disclaimer

By providing this software, I do not give any guarantees of its work. This script was inspired by the work of [LinSoftWin](https://github.com/LinSoftWin/Photoshop-CC2022-Linux). This is only its adaptation. This script will be maintained and developed until I get bored and/or have free time. PR is welcome.

## Showcase 

![image](https://github.com/user-attachments/assets/715d7b83-d872-4e68-983e-daa6704e79ab)
![image](https://github.com/user-attachments/assets/ad8c7477-4682-4edc-8665-4f5b5380a382)

### What works

- Drag and drop
- Mime type (right click menu, see [here](https://github.com/user-attachments/assets/eb5f7ab3-fb75-47e7-841b-a763ca5e3382))
- GPU acceleration

**Tested on:**
- Arch Linux
- KDE Plasma 6.1.5 (Wayland)
- wine 9.19
- AMD GPU

### Known issues

- When hovering on toolbar item to see its instructions, black bars may appear around
- Wine's experimental wayland driver is completely broken

## Installation

```bash
git clone https://github.com/shvedes/photoshop-linux
cd photoshop-linux
./install.sh <installation path>
```
## To Do

- [ ] Uninstall script
- [ ] More checks in the install script
- [ ] Ability for the user to select a default installation folder
