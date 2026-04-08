#!/bin/bash
set -e

# Log everything
exec > /var/log/startup-script.log 2>&1

echo "===== QA VM startup script started ====="

ENV="qa"

# -----------------------------
# Basic system setup
# -----------------------------
apt update -y
apt install -y git curl ca-certificates gnupg

# -----------------------------
# Install gcloud CLI (for Secret Manager)
# -----------------------------
if ! command -v gcloud >/dev/null 2>&1; then
  echo "Installing Google Cloud SDK..."
  curl https://sdk.cloud.google.com | bash
  source /root/.bashrc
fi

# -----------------------------
# Create Linux user from Secret Manager
# -----------------------------
echo "Fetching VM user secrets..."

USERNAME=$(gcloud secrets versions access latest --secret="${ENV}-vm-username")
PASSWORD=$(gcloud secrets versions access latest --secret="${ENV}-vm-password")
SSH_KEY=$(gcloud secrets versions access latest --secret="${ENV}-vm-ssh-public-key")

if ! id "$USERNAME" >/dev/null 2>&1; then
  useradd -m -s /bin/bash "$USERNAME"
  echo "$USERNAME:$PASSWORD" | chpasswd
fi

mkdir -p /home/$USERNAME/.ssh
echo "$SSH_KEY" > /home/$USERNAME/.ssh/authorized_keys
chmod 700 /home/$USERNAME/.ssh
chmod 600 /home/$USERNAME/.ssh/authorized_keys
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh

echo "✅ QA user $USERNAME created (password + SSH enabled)"

# Enable SSH password auth (QA ONLY)
sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd

# -----------------------------
# Fetch DB secrets (MUST be BEFORE app start)
# -----------------------------
echo "Fetching DB secrets..."

export DB_HOST=$(gcloud secrets versions access latest --secret=qa-db-host)
export DB_PORT=$(gcloud secrets versions access latest --secret=qa-db-port)
export DB_NAME=$(gcloud secrets versions access latest --secret=qa-db-name)
export DB_USER=$(gcloud secrets versions access latest --secret=qa-db-user)
export DB_PASSWORD=$(gcloud secrets versions access latest --secret=qa-db-password)

echo "✅ DB environment variables exported"

# -----------------------------
# Install Node.js 18
# -----------------------------
echo "Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

# -----------------------------
# Deploy Node.js application
# -----------------------------
echo "Deploying Node.js application..."

rm -rf /opt/app
git clone https://github.com/ncravikiran/gcp-tf.git /opt/app

cd /opt/app
git checkout qa

cd /opt/app/sample-code
npm install

# -----------------------------
# Install & start PM2 (AFTER env vars)
# -----------------------------
npm install -g pm2

pm2 delete gcp-tf-sample-app || true
pm2 start app.js --name "gcp-tf-sample-app"
pm2 startup systemd -u root --hp /root
pm2 save

# -----------------------------
# Verification
# -----------------------------
echo "Node version: $(node --version)"
echo "NPM version: $(npm --version)"
pm2 status

echo "===== QA VM startup script completed successfully ====="
