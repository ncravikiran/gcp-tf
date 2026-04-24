#!/bin/bash
set -e

apt update -y
apt install -y git curl ca-certificates gnupg

# Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

# PM2
npm install -g pm2

mkdir -p /opt/app
