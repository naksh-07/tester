FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl git vim nano wget python3 python3-pip build-essential \
    htop zram-tools docker.io tlp jq unzip nodejs npm cmake \
    && npm install -g npm yarn pm2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
