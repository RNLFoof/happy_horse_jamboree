#!/bin/bash

echo "Deleting and recreating the build folder..."
rm -r build
mkdir build

echo "Compiling yue... (https://yuescript.org/)"
yue -t build/ source/

echo "Compiling TypeScript into Lua... (https://typescripttolua.github.io/)"
npx tstl

echo "Coping over raw lua (and NES roms) (should be last because it changes directory)"
cd source
find -type f | grep -i -e "lua$" -e "nes$" | xargs -i cp "{}" --parents -t "../build"
