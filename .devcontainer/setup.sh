#!/bin/bash
set -e

echo "🔥 Running setup.sh - One-time config only..."

SETUP_MARKER=".devcontainer/.setup_done"
WORKSPACE_NAME=$(basename "$PWD")
SCRIPTS_DIR=".devcontainer/scripts"

if [ -f "$SETUP_MARKER" ]; then
  echo "✅ Setup already done. Skipping..."
  exit 0
fi

echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor || true
systemctl enable zramswap || true
systemctl enable tlp || true

echo '* soft nofile 1048576' | tee -a /etc/security/limits.conf
echo '* hard nofile 1048576' | tee -a /etc/security/limits.conf
ulimit -n 1048576 || true

mkdir -p "$SCRIPTS_DIR"
cd "$SCRIPTS_DIR"

[ ! -f "thorium.sh" ] && wget -q https://raw.githubusercontent.com/naksh-07/Automate/refs/heads/main/thorium.sh

[ ! -f "ognode.sh" ] && wget -q https://raw.githubusercontent.com/naksh-07/Automate/refs/heads/main/ognode.sh

chmod +x *.sh
./thorium.sh
./gaianet.sh
./ognode.sh

touch "$SETUP_MARKER"
echo "✅ All done! Ultra OP Codespace ready to rumble 🫡"
