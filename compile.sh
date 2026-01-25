#!/bin/bash

# Delete and recreate the build folder
rm -r build
mkdir build

# Compile yue, https://yuescript.org/ 
yue -t build/ source/

# Copy over raw lua (and NES roms), should be last because it changes directory
cd source
find -type f | grep -i -e "lua$" -e "nes$" | xargs -i cp "{}" --parents -t "../build"
