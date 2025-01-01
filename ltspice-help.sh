#!/bin/sh

export WINEPREFIX=$HOME/.local/share/wineprefixes/ltspice WINEARCH=win64
wine hh /usr/share/doc/ltspice/ltspice.chm "$@"
