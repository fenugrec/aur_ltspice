#!/bin/sh

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ltspice"
if [ ! -d "$HOME"/.ltspice ] ; then
   mkdir -p "$HOME"/.ltspice
fi
if [ ! -d $CONFIG_DIR ]; then
   mkdir -p $CONFIG_DIR
   touch $CONFIG_DIR/LTspice.ini
fi
export WINEPREFIX=$HOME/.local/share/wineprefixes/ltspice WINEARCH=win64
wine /usr/lib/wine/x86_64-windows/start.exe /unix /opt/ltspice/LTspice.exe -ini $CONFIG_DIR/LTspice.ini "$@"
