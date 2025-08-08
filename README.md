Mein persönliches NixOS-Flake-Setup für Hyprland – inklusive Home Manager, Waybar, Kitty, Wofi, Thunar, Firefox und eigenen Skripten.

---

- NixOS ISO gestartet
- Internetverbindung (z. B. via `nmtui`)
- Richtige Partitionen (z. B. `/dev/nvme0n1p1` für EFI, `/dev/nvme0n1p2` für `/`, `/dev/nvme0n1p4` für `/home`)

---

### 🔧 Installation `

```bash
lsblk -f # Dateisysteme anzeigen


### Formatieren und mounten ### nvme0n1p1 etc. je nach dem anpassen
sudo mkfs.vfat -F32 /dev/nvme0n1p1          # EFI
sudo mkfs.ext4 /dev/nvme0n1p2               # ROOT
sudo mkswap /dev/nvme0n1p3 && sudo swapon /dev/nvme0n1p3

sudo mount /dev/nvme0n1p2 /mnt
sudo mkdir -p /mnt/boot/efi
sudo mount /dev/nvme0n1p1 /mnt/boot/efi
sudo mkdir -p /mnt/home
sudo mount /dev/nvme0n1p4 /mnt/home         # <- /home behalten

### Repro clonen
cd ~
git clone https://github.com/pretofusia1/nixos-config.git
cd nixos-config

### Flake vorbereiten
sudo nixos-generate-config --root /mnt
mkdir -p hosts/preto
cp /mnt/etc/nixos/hardware-configuration.nix hosts/preto/hardware-configuration.nix

git config --global user.name "Preto"
git config --global user.email "preto@install"
git add hosts/preto/hardware-configuration.nix
git commit -m "Add hardware-configuration.nix"

### Prüfen
git status   # sollte "working tree clean" zeigen

### Install
sudo nixos-install --flake ~/nixos-config#preto


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
