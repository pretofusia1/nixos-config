#!/bin/bash

# 1. Zufälliges Wallpaper aus dem Ordner auswählen
WALL=$(find ~/Pictures/wallpapers -type f | shuf -n 1)

# 2. pywal mit dem Wallpaper ausführen
wal -i "$WALL"

# 3. Warten, bis pywal die Farben generiert hat
while [ ! -f "$HOME/.cache/wal/colors.json" ]; do sleep 0.1; done

# 4. Wallpaper mit hyprpaper setzen
MONITOR=$(hyprctl monitors | grep -oP '^Monitor \K[^ ]+' | head -n1)
hyprctl hyprpaper preload "$WALL"
hyprctl hyprpaper wallpaper "$MONITOR,$WALL"

# 5. btop-Theme aus reinem wal-Farbschema erzeugen
mkdir -p "$HOME/.config/btop/themes"
cat > "$HOME/.config/btop/themes/wal.theme" <<EOF
# 100% pywal-only theme for btop
theme[main_bg]=$(jq -r '.special.background' < ~/.cache/wal/colors.json)
theme[main_fg]=$(jq -r '.special.foreground' < ~/.cache/wal/colors.json)
theme[title]=$(jq -r '.colors.color1' < ~/.cache/wal/colors.json)
theme[hi_fg]=$(jq -r '.colors.color2' < ~/.cache/wal/colors.json)
theme[selected_bg]=$(jq -r '.colors.color3' < ~/.cache/wal/colors.json)
theme[selected_fg]=$(jq -r '.colors.color4' < ~/.cache/wal/colors.json)
theme[inactive_fg]=$(jq -r '.colors.color8' < ~/.cache/wal/colors.json)
theme[proc_misc]=$(jq -r '.colors.color5' < ~/.cache/wal/colors.json)
theme[cpu_box]=$(jq -r '.colors.color6' < ~/.cache/wal/colors.json)
theme[mem_box]=$(jq -r '.colors.color7' < ~/.cache/wal/colors.json)
theme[net_box]=$(jq -r '.colors.color0' < ~/.cache/wal/colors.json)
theme[proc_box]=$(jq -r '.colors.color1' < ~/.cache/wal/colors.json)
theme[graph_text]=$(jq -r '.special.foreground' < ~/.cache/wal/colors.json)
theme[bar_bg]=$(jq -r '.colors.color0' < ~/.cache/wal/colors.json)
theme[bar_fg]=$(jq -r '.colors.color7' < ~/.cache/wal/colors.json)
theme[download_start]=$(jq -r '.colors.color3' < ~/.cache/wal/colors.json)
theme[download_mid]=$(jq -r '.colors.color3' < ~/.cache/wal/colors.json)
theme[download_end]=$(jq -r '.colors.color3' < ~/.cache/wal/colors.json)
theme[upload_start]=$(jq -r '.colors.color2' < ~/.cache/wal/colors.json)
theme[upload_mid]=$(jq -r '.colors.color2' < ~/.cache/wal/colors.json)
theme[upload_end]=$(jq -r '.colors.color2' < ~/.cache/wal/colors.json)
theme[temp_start]=$(jq -r '.colors.color4' < ~/.cache/wal/colors.json)
theme[temp_mid]=$(jq -r '.colors.color4' < ~/.cache/wal/colors.json)
theme[temp_end]=$(jq -r '.colors.color4' < ~/.cache/wal/colors.json)
theme[cpu_low]=$(jq -r '.colors.color6' < ~/.cache/wal/colors.json)
theme[cpu_high]=$(jq -r '.colors.color6' < ~/.cache/wal/colors.json)
theme[free_mem]=$(jq -r '.colors.color7' < ~/.cache/wal/colors.json)
theme[div_line]=$(jq -r '.colors.color8' < ~/.cache/wal/colors.json)
theme[menu_fg]=$(jq -r '.colors.color6' < ~/.cache/wal/colors.json)
theme[menu_bg]=$(jq -r '.colors.color0' < ~/.cache/wal/colors.json)
EOF

# <-- HIER danach:
#kitty --class monitorterm -e btop &
