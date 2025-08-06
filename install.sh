#!/usr/bin/env bash
set -euo pipefail

# ✳️ Partitionen definieren
DISK_BOOT="/dev/nvme0n1p1"
DISK_ROOT="/dev/nvme0n1p2"
DISK_HOME="/dev/nvme0n1p4"
MNT="/mnt"

echo "🧊 Minimal-NixOS-Installationsskript (Flake-basiert)"

# 🔐 Sicherheitsabfrage zum Formatieren
read -rp "⚠️ Möchtest du die ROOT-Partition ($DISK_ROOT) formatieren? [y/N]: " CONFIRM_ROOT
if [[ "$CONFIRM_ROOT" =~ ^[Yy]$ ]]; then
    echo "📛 Formatiere $DISK_ROOT als ext4..."
    mkfs.ext4 -L nixos "$DISK_ROOT"
fi

read -rp "⚠️ Möchtest du die BOOT-Partition ($DISK_BOOT) formatieren? [y/N]: " CONFIRM_BOOT
if [[ "$CONFIRM_BOOT" =~ ^[Yy]$ ]]; then
    echo "📛 Formatiere $DISK_BOOT als FAT32..."
    mkfs.vfat -F32 "$DISK_BOOT"
fi

# 📦 Partitionen mounten
echo "📂 Mounten der Partitionen..."
mount | grep "$MNT" && echo "⚠️ WARNUNG: $MNT ist bereits gemountet. Breche ab." && exit 1

mount "$DISK_ROOT" $MNT
mkdir -p $MNT/home
mount "$DISK_HOME" $MNT/home
mkdir -p $MNT/boot/efi
mount "$DISK_BOOT" $MNT/boot/efi

# 🌍 Internetverbindung prüfen
echo "🌐 Prüfe Internetverbindung zu github.com..."
if ! ping -c 1 github.com >/dev/null 2>&1; then
    echo "❌ Keine Internetverbindung. Bitte Netzwerk manuell konfigurieren (z. B. mit 'ip', 'wpa_supplicant' oder 'nmtui')."
    exit 1
fi

# 📥 Konfiguration klonen
echo "📥 Klone Konfiguration von GitHub..."
rm -rf $MNT/etc/nixos
if ! git clone https://github.com/pretofusia1/nixos-config $MNT/etc/nixos; then
    echo "❌ Fehler: Konnte Repository nicht klonen. Prüfe Netzwerk oder Repository-Zugriff!"
    exit 1
fi

# ⚙️ Hardware-Konfiguration erzeugen (nur wenn nicht vorhanden)
if [[ ! -f "$MNT/etc/nixos/hardware-configuration.nix" ]]; then
    echo "⚙️ Generiere hardware-configuration.nix..."
    nixos-generate-config --root $MNT
else
    echo "✔️ hardware-configuration.nix bereits vorhanden, überspringe..."
fi

# 🚀 NixOS installieren
echo "🚀 Starte NixOS-Installation mit Flake..."
nixos-install --flake $MNT/etc/nixos#preto

echo "✅ Installation abgeschlossen. Du kannst jetzt neu starten."
