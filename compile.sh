#!/bin/bash
rm -r build
mkdir build

yue -t build/ source/

cd source
find -type f | grep -i -e "lua$" -e "nes$" | xargs -i cp "{}" --parents -t "../build"
