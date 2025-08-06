Mein persönliches NixOS-Flake-Setup für Hyprland – inklusive Home Manager, Waybar, Kitty, Wofi, Thunar, Firefox und eigenen Skripten.

---

- NixOS ISO gestartet
- Internetverbindung (z. B. via `nmtui`)
- Richtige Partitionen (z. B. `/dev/nvme0n1p1` für EFI, `/dev/nvme0n1p2` für `/`, `/dev/nvme0n1p4` für `/home`)

---

### 🔧 Installation mit `install.sh`

```bash
curl -O https://raw.githubusercontent.com/pretofusia1/nixos-config/main/install.sh
chmod +x install.sh
./install.sh

# 🧊 nixos-config


## 🔧 Setup

- Window Manager: [Hyprland](https://github.com/hyprwm/Hyprland)
- Display Manager: greetd + tuigreet
- Bar: [Waybar](https://github.com/Alexays/Waybar)
- Terminal: Kitty
- Dateimanager: Thunar
- Browser: Firefox
- Skripte: eigene Screenshot-, Wallpaper- und Fastfetch-Tools
- Wallpaper: dynamisch mit `hyprpaper` + `wallpaper-wal.sh`

## 📁 Struktur

```bash
.
├── flake.nix                  # Zentrale Flake-Konfiguration
├── configuration.nix         # Systemkonfiguration
├── home.nix                  # Home Manager User-Konfig
├── config/
│   ├── hyprland.conf
│   ├── hyprpaper.conf
│   └── waybar/
│       ├── config.jsonc
│       └── style.css
├── scripts/
│   ├── wallpaper-wal.sh
│   ├── fastfetch-colored.sh
│   ├── screenshot-full.sh
│   └── screenshot-area.sh
├── wallpapers/               # Hintergrundbilder
└── install.sh                # Automatisches Setup-Skript
