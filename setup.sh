#!/bin/bash

# Bhai, this is your full OP Codespace setup in one script 💪

WORKSPACE_NAME=$(basename "$PWD")
DEVCONTAINER_DIR=".devcontainer"
FULL_PATH="$PWD/$DEVCONTAINER_DIR"
SCRIPT_DIR="$FULL_PATH/scripts"

echo "🚀 Creating Ultra OP DevContainer setup in $DEVCONTAINER_DIR..."

mkdir -p "$SCRIPT_DIR"

# Step 1: devcontainer.json
cat <<EOF > "$FULL_PATH/devcontainer.json"
{
  "name": "OP Ubuntu Dev Container 4Core-16GB",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu-22.04",
  "features": {
    "ghcr.io/devcontainers/features/docker-in-docker:2": {}
  },
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-azuretools.vscode-docker"
      ],
      "settings": {
        "workbench.startupEditor": "none",
        "terminal.integrated.shellIntegration.enabled": false
      }
    }
  },
  "hostRequirements": {
    "cpus": 4,
    "memory": "16gb"
  },
  "postCreateCommand": "bash .devcontainer/setup.sh",
  "remoteUser": "root"
}
EOF
echo "✅ devcontainer.json created."

# Step 2: Dockerfile
cat <<EOF > "$FULL_PATH/Dockerfile"
FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \\
    curl git vim nano wget python3 python3-pip build-essential \\
    htop zram-tools docker.io tlp jq unzip nodejs npm cmake \\
    && npm install -g npm yarn pm2 \\
    && apt-get clean && rm -rf /var/lib/apt/lists/*
EOF
echo "✅ Dockerfile created."

# Step 3: setup.sh
cat <<EOF > "$FULL_PATH/setup.sh"
#!/bin/bash
set -e

echo "🔥 Running setup.sh - One-time config only..."

SETUP_MARKER=".devcontainer/.setup_done"
WORKSPACE_NAME=\$(basename "\$PWD")
SCRIPTS_DIR=".devcontainer/scripts"

if [ -f "\$SETUP_MARKER" ]; then
  echo "✅ Setup already done. Skipping..."
  exit 0
fi

echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor || true
systemctl enable zramswap || true
systemctl enable tlp || true

echo '* soft nofile 1048576' | tee -a /etc/security/limits.conf
echo '* hard nofile 1048576' | tee -a /etc/security/limits.conf
ulimit -n 1048576 || true

mkdir -p "\$SCRIPTS_DIR"
cd "\$SCRIPTS_DIR"

[ ! -f "thorium.sh" ] && wget -q https://raw.githubusercontent.com/naksh-07/Automate/refs/heads/main/thorium.sh

[ ! -f "ognode.sh" ] && wget -q https://raw.githubusercontent.com/naksh-07/Automate/refs/heads/main/ognode.sh

chmod +x *.sh
./thorium.sh
./gaianet.sh
./ognode.sh

touch "\$SETUP_MARKER"
echo "✅ All done! Ultra OP Codespace ready to rumble 🫡"
EOF
chmod +x "$FULL_PATH/setup.sh"
echo "✅ setup.sh ready."

echo -e "\n🎉 All done bhai! Your Ultra OP Codespace is locked & loaded.\n👉 Run this to launch or rebuild Codespace:"
echo "   devcontainer rebuild-container"
