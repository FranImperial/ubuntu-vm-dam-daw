# Ubuntu VM para DAM + DAW

Script que deja lista, en un solo paso, una máquina virtual **Ubuntu 26.04 ARM64** en
**UTM** (Mac con Apple Silicon, probado en un M3) para el ciclo de DAM + DAW.

Se puede ejecutar varias veces sin problema: lo que ya está instalado se salta.

## Uso

Dentro de la VM:

```bash
bash instalar-apps.sh
```

Al terminar, reinicia la VM para que se apliquen los grupos (`docker`, `wireshark`) y el
portapapeles compartido.

## Qué instala

| Bloque | Contenido |
|---|---|
| Integración con el Mac | `spice-vdagent`, `spice-webdavd`, `qemu-guest-agent`: portapapeles, ajuste de pantalla y carpeta compartida |
| Herramientas básicas | git, build-essential, neovim, htop/btop, fastfetch, timeshift, flameshot, VLC, GIMP, FileZilla, Flatpak + Flathub |
| Editores e IA | Visual Studio Code, Antigravity, Claude (app de escritorio) y Claude Code |
| Programación | Java 21 + Maven, Python (pip, venv, pipx), Node.js + npm, PHP + Apache + Composer |
| Bases de datos | MariaDB, SQLite y DBeaver |
| Otros | Docker + Compose, Wireshark, Postman, Obsidian, Telegram, Flatseal, Extension Manager |

Apache y MariaDB se instalan **desactivados** para no gastar recursos. Se arrancan cuando
hacen falta en clase:

```bash
sudo systemctl start apache2 mariadb
```

## Requisitos

- UTM con una VM Ubuntu 26.04 ARM64 y conexión a internet. Si la VM no tiene red, el script
  avisa y se detiene: en UTM, pon la red en modo *Emulated VLAN* y vuelve a ejecutarlo.
- Un usuario con permisos de `sudo`.
