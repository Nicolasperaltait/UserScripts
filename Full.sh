#Script Created by Nicolas Peralta

#!/bin/bash

# Basics Instalation (tu versión completa)
sudo apt install ufw clamav clamav-daemon git wget curl zsh htop preload nala fastfetch -y

# Permite acceso a OMV desde el explorador de archivos (Thunar)
sudo apt install gvfs-backends gvfs-fuse -y

# Deshabilitar Avahi
sudo systemctl disable --now avahi-daemon.service avahi-daemon.socket

# Firewall Setup básico con UFW
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw limit 22/tcp comment 'SSH con limitación'
sudo ufw limit 3389/tcp comment 'RDP con limitación'

# Activación del firewall
sudo ufw enable
sudo ufw reload

# Anti Virus - ClamAV
sudo systemctl stop clamav-freshclam
sudo freshclam
sudo systemctl start clamav-freshclam
sudo systemctl start clamav-daemon

# ============================================================
# Hardering de Seguridad en Debian 13
# Autor: Nicolás Peralta 
# Descripción:
#   Aplica un baseline de seguridad para Debian 13:
#     - Paquetes de seguridad básicos
#     - UFW (deny incoming, allow outgoing, SSH/RDP limit)
#     - Unattended-upgrades (actualizaciones automáticas)
#     - Hardening de kernel (sysctl)
#     - Hardening SSH (sshd_config.d)
#     - Fail2ban (jail básico para SSH)
#     - ClamAV + AppArmor
# ============================================================

set -euo pipefail

# ---------------------------
# Funciones auxiliares
# ---------------------------
log() {
  echo -e "[*] $*"
}

check_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    echo "[X] Este script debe ejecutarse como root (sudo)."
    exit 1
  fi
}

backup_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    cp -a "$file" "${file}.bak_$(date +%F_%H%M%S)"
    log "Backup de $file creado."
  fi
}

# ---------------------------
# 1) Paquetes de seguridad
# ---------------------------
instalar_paquetes() {
  log "Actualizando índices de paquetes..."
  apt update

  log "Instalando paquetes de seguridad y utilidades..."
  apt install -y \
    ufw \
    fail2ban \
    unattended-upgrades \
    apt-listchanges \
    logwatch \
    clamav \
    clamav-daemon \
    apparmor \
    apparmor-utils
}

# ---------------------------
# 2) Unattended-upgrades
# ---------------------------
config_unattended_upgrades() {
  log "Configurando actualizaciones automáticas (unattended-upgrades)..."

  # Fuerza activación diaria de actualizaciones
  cat > /etc/apt/apt.conf.d/20auto-upgrades <<'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
EOF

  systemctl enable unattended-upgrades
  systemctl restart unattended-upgrades

  log "unattended-upgrades habilitado."
}

# ---------------------------
# 3) Firewall UFW
# ---------------------------
config_ufw() {
  log "Configurando UFW (deny incoming / allow outgoing, SSH y RDP con limit)..."

  # Reseteo básico de reglas (opcional, pero limpio)
  ufw --force reset

  ufw default deny incoming
  ufw default allow outgoing

  # Mantener SSH y RDP como veníamos usando: limit para mitigar brute force
  ufw limit 22/tcp comment 'SSH (limit)'
  ufw limit 3389/tcp comment 'RDP (xRDP, limit)'

  # Si quisieras ping desde afuera, ufw ya lo permite por defecto (ICMP).
  # Si querés bloquear, habría que usar /etc/ufw/before.rules (no lo tocamos acá).

  # Activar sin prompt interactivo
  ufw --force enable

  log "UFW habilitado. Reglas actuales:"
  ufw status verbose
}

# ---------------------------
# 4) Hardening de kernel (sysctl)
# ---------------------------
config_sysctl() {
  log "Aplicando hardening de kernel y red (sysctl)..."

  local sysctl_file="/etc/sysctl.d/99-seguridad-debian13.conf"
  backup_file "$sysctl_file"

  cat > "$sysctl_file" <<'EOF'
##########################################
# Hardening de red IPv4
##########################################
net.ipv4.ip_forward = 0

# Anti-spoofing (reverse path filter)
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# No aceptar ni enviar redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# No aceptar source routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0

# Protección frente a SYN flood
net.ipv4.tcp_syncookies = 1

# ICMP: evitar floods/broadcasts raros
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1

##########################################
# Hardening general de kernel
##########################################
# ASLR
kernel.randomize_va_space = 2

# Ocultar direcciones del kernel
kernel.kptr_restrict = 2

# Restringir dmesg a root
kernel.dmesg_restrict = 1

# Bloquear user namespaces no privilegiados (reduce superficie de ataques)
kernel.unprivileged_userns_clone = 0

# Desactivar kexec (evitar salto de kernel sin pasar por bootloader)
kernel.kexec_load_disabled = 1

# Restringir ptrace
kernel.yama.ptrace_scope = 1

# Desactivar SysRq (Ctrl+Alt+SysRq)
kernel.sysrq = 0
EOF

  sysctl --system

  log "Parámetros sysctl aplicados."
}

# ---------------------------
# 5) Hardening SSH
# ---------------------------
config_sshd() {
  log "Aplicando hardening básico de SSH..."

  local sshd_dropin="/etc/ssh/sshd_config.d/99-debian13-hardening.conf"
  mkdir -p /etc/ssh/sshd_config.d

  backup_file "$sshd_dropin"

  cat > "$sshd_dropin" <<'EOF'
# ===========================
# Hardening SSH Debian 13
# ===========================
Protocol 2
PermitRootLogin no
MaxAuthTries 3
MaxSessions 5
LoginGraceTime 30
ClientAliveInterval 300
ClientAliveCountMax 2

# Por defecto no tocamos PasswordAuthentication para no dejarte afuera.
# Si luego tenés claves configuradas, podés agregar:
#   PasswordAuthentication no

X11Forwarding no
EOF

  # Validar configuración antes de recargar
  if sshd -t; then
    systemctl reload ssh || systemctl reload sshd || true
    log "Configuración SSH recargada correctamente."
  else
    log "ERROR: sshd -t falló. Revisa /etc/ssh/sshd_config* antes de recargar."
  fi
}

# ---------------------------
# 6) Fail2ban
# ---------------------------
config_fail2ban() {
  log "Configurando Fail2ban para SSH..."

  mkdir -p /etc/fail2ban/jail.d

  local jail_file="/etc/fail2ban/jail.d/sshd-debian13-hardening.local"
  backup_file "$jail_file"

  cat > "$jail_file" <<'EOF'
[sshd]
enabled  = true
port     = ssh
filter   = sshd
logpath  = /var/log/auth.log
maxretry = 5
findtime = 10m
bantime  = 1h
EOF

  systemctl enable fail2ban
  systemctl restart fail2ban

  log "Fail2ban habilitado y jail de SSH configurada."
}

# ---------------------------
# 7) ClamAV + AppArmor
# ---------------------------
config_clamav_apparmor() {
  log "Actualizando firmas de ClamAV y habilitando servicios..."

  # Puede tardar un poco la primera vez
  systemctl stop clamav-freshclam || true
  freshclam || true
  systemctl enable clamav-freshclam
  systemctl start clamav-freshclam

  systemctl enable clamav-daemon
  systemctl start clamav-daemon

  log "ClamAV daemon y freshclam activos."

  log "Verificando AppArmor..."
  systemctl enable apparmor
  systemctl start apparmor || true
  aa-status || true
}

# ---------------------------
# MAIN
# ---------------------------
main() {
  check_root

  log "===== Hardening de seguridad para Debian 13 ====="

  instalar_paquetes
  config_unattended_upgrades
  config_ufw
  config_sysctl
  config_sshd
  config_fail2ban
  config_clamav_apparmor

  log "===== Hardening completo. Reiniciar el equipo es recomendable. ====="
}

main "$@"

# ============================================================
# Perzonalización Zsh + Oh My Zsh

cd /home/nicolas
sudo apt update && sudo apt install zsh curl git -y

export RUNZSH=no
yes |  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

sudo chsh -s $(which zsh) &&

yes | wget -O ~/.oh-my-zsh/themes/kali-like.zsh-theme https://raw.githubusercontent.com/clamy54/kali-like-zsh-theme/master/kali-like.zsh-theme

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

cat << 'EOF' >> ~/.zshrc

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="kali-like"
plugins=(git
sudo
zsh-syntax-highlighting
zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

EOF

zsh

