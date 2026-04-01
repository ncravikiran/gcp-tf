#!/bin/bash

# Log everything to /var/log/startup-script.log
exec > /var/log/startup-script.log 2>&1

apt update -y
apt install -y git curl

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

# Clone your repo fresh
rm -rf /opt/app
git clone https://github.com/ncravikiran/gcp-tf.git /opt/app

# Checkout correct branch
cd /opt/app
git checkout qa

# Install Node.js dependencies
cd /opt/app/sample-code
npm install

# Install PM2 process manager
npm install -g pm2

# Start your Node.js app
pm2 start app.js --name "gcp-tf-sample-app"

# Enable PM2 startup on reboot
pm2 startup systemd -u root --hp /root
pm2 save

# Print versions for verification
node --version
npm --version
pm2 status
