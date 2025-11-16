# ==========================================================
# XFCE - Configuración de accesos directos simples
# Super + número -> mover ventana activa al escritorio
# Alt + número   -> cambiar al escritorio
# Solo escritorios 1–4
# ==========================================================

sudo apt install -y wmctrl

# Limpieza previa (evita conflictos)
for i in {0..9}; do
  xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Super>$i" -r 2>/dev/null
  xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Alt>$i" -r 2>/dev/null
done

# Definir atajos del 1 al 4
for i in {1..4}; do
  # Super + N → mover ventana activa al escritorio N
  xfconf-query -c xfce4-keyboard-shortcuts \
    -p "/commands/custom/<Super>$i" \
    -n -t string \
    -s "bash -c 'wmctrl -r :ACTIVE: -t $((i-1))'"

  # Alt + N → cambiar al escritorio N
  xfconf-query -c xfce4-keyboard-shortcuts \
    -p "/commands/custom/<Alt>$i" \
    -n -t string \
    -s "bash -c 'wmctrl -s $((i-1))'"
done

# Confirmación visual
echo -e "\n✅ Atajos XFCE configurados correctamente:\n"
xfconf-query -c xfce4-keyboard-shortcuts -l -v | grep wmctrl
