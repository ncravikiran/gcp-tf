#!/bin/bash
set -e
exec > /var/log/startup.log 2>&1
echo "===== QA VM startup script started ====="
ENV="qa"
 
# ------------------------------
# System setup
# ------------------------------
apt-get update -y
apt-get install -y git curl ca-certificates gnupg
 
# ------------------------------
# Install gcloud if missing
# ------------------------------
if ! command -v gcloud >/dev/null 2>&1; then
  echo "Installing Google Cloud SDK..."
  curl https://sdk.cloud.google.com | bash
fi
 
if [ -f /root/google-cloud-sdk/path.bash.inc ]; then
  source /root/google-cloud-sdk/path.bash.inc
fi
 
export PATH=$PATH:/root/google-cloud-sdk/bin
 
if ! command -v gcloud >/dev/null 2>&1; then
  echo "ERROR: gcloud not found after install. Aborting."
  exit 1
fi
 
# ------------------------------
# Create Linux user
# ------------------------------
USERNAME=$(gcloud secrets versions access latest --secret="${ENV}-vm-username")
PASSWORD=$(gcloud secrets versions access latest --secret="${ENV}-vm-password")
SSH_KEY=$(gcloud secrets versions access latest --secret="${ENV}-vm-ssh-public-key")
 
if [[ -z "$USERNAME" || -z "$PASSWORD" || -z "$SSH_KEY" ]]; then
  echo "✗ VM user secrets missing"
  exit 1
fi
 
if ! id "$USERNAME" >/dev/null 2>&1; then
  useradd -m -s /bin/bash "$USERNAME"
  echo "$USERNAME:$PASSWORD" | chpasswd
fi
 
mkdir -p /home/$USERNAME/.ssh
echo "$SSH_KEY" > /home/$USERNAME/.ssh/authorized_keys
chmod 700 /home/$USERNAME/.ssh
chmod 600 /home/$USERNAME/.ssh/authorized_keys
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
 
# FIX: Allow user passwordless sudo (needed for Cloud Build deployment)
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
 
# Enable SSH password auth
sed -i -E 's/^#?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd
 
# ------------------------------
# Fetch DB secrets → env file
# ------------------------------
echo "Creating DB env file..."
DB_HOST=$(gcloud secrets versions access latest --secret=qa-db-host)
DB_PORT=$(gcloud secrets versions access latest --secret=qa-db-port)
DB_NAME=$(gcloud secrets versions access latest --secret=qa-db-name)
DB_USER=$(gcloud secrets versions access latest --secret=qa-db-user)
DB_PASSWORD=$(gcloud secrets versions access latest --secret=qa-db-password)
 
if [[ -z "$DB_HOST" || -z "$DB_PORT" || -z "$DB_NAME" || -z "$DB_USER" || -z "$DB_PASSWORD" ]]; then
  echo "✗ Database secrets missing"
  exit 1
fi
 
cat <<EOF > /opt/app.env
DB_HOST=$DB_HOST
DB_PORT=$DB_PORT
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
EOF
 
chmod 600 /opt/app.env
 
# ------------------------------
# Install Node.js 18
# ------------------------------
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs
node --version
npm --version
 
# ------------------------------
# Install PM2
# ------------------------------
npm install -g pm2
pm2 --version
pm2 startup systemd -u root --hp /root | tail -n 1 | bash
 
# ------------------------------
# Prepare app directory
# ------------------------------
mkdir -p /opt/app
chown -R $USERNAME:$USERNAME /opt/app
 
echo "===== VM is ready. Waiting for Cloud Build to deploy. ====="
