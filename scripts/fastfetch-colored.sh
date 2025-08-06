#!/bin/bash

# Warte, bis pywal-Farben vorhanden sind
until grep -q "color0=" ~/.cache/wal/colors.sh 2>/dev/null; do sleep 0.1; done

# Farben laden
source ~/.cache/wal/colors.sh
[ -f ~/.cache/wal/sequences ] && cat ~/.cache/wal/sequences

# Fastfetch starten
clear
fastfetch --logo arch --logo-recache

# Shell offen halten
exec bash
