#!/bin/bash

git clone https://github.com/Winetricks/winetricks /tmp/ps-winetricks
cd /tmp/ps-winetricks
sudo make install

rm -rf /tmp/ps-winetricks/
