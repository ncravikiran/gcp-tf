#!/bin/bash 
apt update -y
apt install -y git curl

# Update and install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo bash -
sudo apt install -y nodejs

rm -rf /opt/app
git clone https://github.com/ncravikiran/gcp-tf.git /opt/app
cd /opt/app
git checkout qa
cd /opt/app/gcp-tf/sample-code
npm install

npm install -g pm2
pm2 start app.js --name "gcp-tf-sample-app"

pm2 startup systemd
pm2 save


# Verify
node --version
npm --version