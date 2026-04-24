#!/bin/bash
set -e

exec > /var/log/startup 2>&1
echo "===== QA VM startup script started ====="

ENV="qa"

# -----------------------------
# System setup
# -----------------------------
apt update -y
apt install -y git curl ca-certificates gnupg

# -----------------------------
# Install gcloud if missing
# -----------------------------
if ! command -v gcloud >/dev/null 2>&1; then
  echo "Installing Google Cloud SDK..."
  curl https://sdk.cloud.google.com | bash
  source /root/.bashrc
fi

# -----------------------------
# Create Linux user
# -----------------------------
USERNAME=$(gcloud secrets versions access latest --secret="${ENV}-vm-username")
PASSWORD=$(gcloud secrets versions access latest --secret="${ENV}-vm-password")
SSH_KEY=$(gcloud secrets versions access latest --secret="${ENV}-vm-ssh-public-key")

if [[ -z "$USERNAME" || -z "$PASSWORD" || -z "$SSH_KEY" ]]; then
  echo "❌ VM user secrets missing"
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

# Enable SSH password auth (QA ONLY)
sed -i -E 's/^#?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd

# -----------------------------
# Fetch DB secrets → env file
# -----------------------------
echo "Creating DB env file..."

DB_HOST=$(gcloud secrets versions access latest --secret=qa-db-host)
DB_PORT=$(gcloud secrets versions access latest --secret=qa-db-port)
DB_NAME=$(gcloud secrets versions access latest --secret=qa-db-name)
DB_USER=$(gcloud secrets versions access latest --secret=qa-db-user)
DB_PASSWORD=$(gcloud secrets versions access latest --secret=qa-db-password)

if [[ -z "$DB_HOST" || -z "$DB_PORT" || -z "$DB_NAME" || -z "$DB_USER" || -z "$DB_PASSWORD" ]]; then
  echo "❌ Database secrets missing"
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
chown root:root /opt/app.env

# -----------------------------
# Install Node.js
# -----------------------------
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

# -----------------------------
# Deploy app
# -----------------------------
rm -rf /opt/app
git clone https://github.com/ncravikiran/gcp-tf.git /opt/app
cd /opt/app && git checkout qa
cd /opt/app/sample-code && npm install

# -----------------------------
# Start PM2 with env file
# -----------------------------
# NOTE: PM2 intentionally runs as root in QA for simplicity
npm install -g pm2

pm2 delete gcp-tf-sample-app || true
pm2 start app.js \
  --name gcp-tf-sample-app \
  --env-file /opt/app.env

pm2 startup systemd -u root --hp /root
pm2 save

# -----------------------------
# Verification
# -----------------------------
node --version
npm --version
pm2 status

echo "===== QA VM startup script completed successfully ====="
