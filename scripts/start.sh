#!/bin/bash
set -e

echo "=== Paperclip Railway Startup ==="
echo "Date: $(date)"

PORT="${PORT:-3100}"
PAPERCLIP_URL="${PAPERCLIP_URL:-http://localhost:$PORT}"
HOSTNAME=$(echo "$PAPERCLIP_URL" | sed 's|https\?://||' | sed 's|/.*||')

# Paperclip expects config at ~/.paperclip/instances/default/config.json
PAPERCLIP_HOME="/root/.paperclip"
INSTANCE_DIR="$PAPERCLIP_HOME/instances/default"
CONFIG_PATH="$INSTANCE_DIR/config.json"

echo "Port: $PORT"
echo "URL: $PAPERCLIP_URL"
echo "Hostname: $HOSTNAME"
echo "Config path: $CONFIG_PATH"

# Create all required directories
mkdir -p "$INSTANCE_DIR/db"
mkdir -p "$INSTANCE_DIR/logs"
mkdir -p "$INSTANCE_DIR/data/backups"
mkdir -p "$INSTANCE_DIR/data/storage"
mkdir -p "$INSTANCE_DIR/secrets"

# Always generate fresh config
echo "Generating config.json..."
cat > "$CONFIG_PATH" <<EOF
{
  "\$meta": {
    "version": 1,
    "updatedAt": "$(date -u +%Y-%m-%dT%H:%M:%S.000Z)",
    "source": "railway"
  },
  "database": {
    "mode": "embedded-postgres",
    "embeddedPostgresDataDir": "$INSTANCE_DIR/db",
    "embeddedPostgresPort": 54329,
    "backup": {
      "enabled": true,
      "intervalMinutes": 60,
      "retentionDays": 30,
      "dir": "$INSTANCE_DIR/data/backups"
    }
  },
  "logging": {
    "mode": "file",
    "logDir": "$INSTANCE_DIR/logs"
  },
  "server": {
    "deploymentMode": "authenticated",
    "exposure": "public",
    "host": "0.0.0.0",
    "port": $PORT,
    "publicUrl": "$PAPERCLIP_URL",
    "allowedHostnames": ["$HOSTNAME"],
    "serveUi": true
  },
  "auth": {
    "baseUrlMode": "explicit",
    "publicBaseUrl": "$PAPERCLIP_URL",
    "disableSignUp": false
  },
  "telemetry": {
    "enabled": true
  },
  "storage": {
    "provider": "local_disk",
    "localDisk": {
      "baseDir": "$INSTANCE_DIR/data/storage"
    }
  },
  "secrets": {
    "provider": "local_encrypted",
    "strictMode": false,
    "localEncrypted": {
      "keyFilePath": "$INSTANCE_DIR/secrets/master.key"
    }
  }
}
EOF

echo "Config written:"
cat "$CONFIG_PATH"
echo ""
echo "Starting Paperclip..."
exec paperclipai run
