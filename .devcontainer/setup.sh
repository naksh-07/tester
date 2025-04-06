#!/bin/bash

echo "🔥 Running OP Setup - Performance Mode ON..."

apt update && apt install -y python3-venv tlp unzip jq && apt clean && rm -rf /var/lib/apt/lists/*

echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
systemctl restart zramswap
systemctl start docker
systemctl enable tlp && systemctl start tlp

npm install -g npm yarn pm2

echo '* soft nofile 1048576' | tee -a /etc/security/limits.conf
echo '* hard nofile 1048576' | tee -a /etc/security/limits.conf
ulimit -n 1048576

cd "/workspaces/tester"
wget -q https://raw.githubusercontent.com/naksh-07/Automate/refs/heads/main/thorium.sh && chmod +x thorium.sh && ./thorium.sh

curl -sSLO https://raw.githubusercontent.com/naksh-07/Automate/refs/heads/main/gaianet.sh && bash gaianet.sh
curl -sSLO https://raw.githubusercontent.com/naksh-07/Automate/refs/heads/main/ognode.sh && bash ognode.sh

echo "✅ All Done Bhai! Ultra OP Container READY 🚀"
