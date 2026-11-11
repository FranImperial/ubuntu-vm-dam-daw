#!/usr/bin/env bash
# Instalación de apps para la VM Ubuntu 26.04 ARM64 (UTM en Mac M3).
# Uso dentro de Ubuntu:  bash instalar-apps.sh
# Se puede volver a ejecutar sin problema: lo ya instalado se salta.

set -u
paso() { printf '\n\033[1;35m==> %s\033[0m\n' "$1"; }

paso "Comprobando conexión a internet"
if ! curl -fsS --max-time 10 https://archive.ubuntu.com >/dev/null; then
  echo "La VM no tiene internet. Arregla la red de UTM (modo Emulated VLAN) y vuelve a ejecutar."
  exit 1
fi

sudo apt update && sudo apt full-upgrade -y

paso "Integración con el Mac (portapapeles, ajuste de pantalla, carpeta compartida)"
sudo apt install -y spice-vdagent spice-webdavd qemu-guest-agent

paso "Herramientas básicas"
sudo apt install -y curl wget git gpg ca-certificates build-essential \
  unzip p7zip-full htop btop fastfetch tree neovim net-tools \
  flatpak timeshift flameshot vlc gimp filezilla

sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

paso "Claude (app oficial, beta para Linux)"
sudo curl -fsSLo /usr/share/keyrings/claude-desktop-archive-keyring.asc \
  https://downloads.claude.ai/claude-desktop/key.asc
echo "deb [signed-by=/usr/share/keyrings/claude-desktop-archive-keyring.asc] https://downloads.claude.ai/claude-desktop/apt/stable stable main" \
  | sudo tee /etc/apt/sources.list.d/claude-desktop.list >/dev/null

paso "Antigravity (IDE de Google)"
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg \
  | sudo gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" \
  | sudo tee /etc/apt/sources.list.d/antigravity.list >/dev/null

paso "Visual Studio Code"
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
  | sudo gpg --dearmor --yes -o /etc/apt/keyrings/microsoft.gpg
echo "deb [arch=arm64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
  | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null

sudo apt update
sudo apt install -y claude-desktop antigravity code

paso "Programación: Java, Python, Node, PHP, bases de datos, Docker"
sudo apt install -y openjdk-21-jdk maven \
  python3-pip python3-venv pipx \
  nodejs npm \
  apache2 php libapache2-mod-php php-mysql php-cli composer \
  mariadb-server sqlite3 \
  docker.io docker-compose-v2 \
  wireshark
sudo usermod -aG docker,wireshark "$USER"
# Los servicios no arrancan solos: actívalos cuando los necesites en clase
# (sudo systemctl start apache2 / mariadb).
sudo systemctl disable --now apache2 mariadb 2>/dev/null || true

paso "Claude Code (terminal)"
curl -fsSL https://claude.ai/install.sh | bash

paso "Apps de Flathub (uso diario y desarrollo)"
flatpak install -y --noninteractive flathub \
  md.obsidian.Obsidian \
  org.telegram.desktop \
  io.dbeaver.DBeaverCommunity \
  com.getpostman.Postman \
  com.github.tchx84.Flatseal \
  com.mattjakeman.ExtensionManager

paso "Listo"
echo "Reinicia la VM para que se apliquen los grupos (docker, wireshark) y el portapapeles compartido."
