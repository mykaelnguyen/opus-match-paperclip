#!/bin/bash
set -e

CONFIG_PATH="/data/paperclip/config.json"
PORT="${PORT:-3100}"
PAPERCLIP_URL="${PAPERCLIP_URL:-http://localhost:$PORT}"

# Extract hostname from PAPERCLIP_URL
HOSTNAME=$(echo "$PAPERCLIP_URL" | sed 's|https\?://||' | sed 's|/.*||')

echo "=== Paperclip Railway Startup ==="
echo "Port: $PORT"
echo "URL: $PAPERCLIP_URL"
echo "Hostname: $HOSTNAME"

# Generate config.json if it doesn't exist
if [ ! -f "$CONFIG_PATH" ]; then
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
    "embeddedPostgresDataDir": "/data/paperclip/db",
    "embeddedPostgresPort": 54329,
    "backup": {
      "enabled": true,
      "intervalMinutes": 60,
      "retentionDays": 30,
      "dir": "/data/paperclip/backups"
    }
  },
  "logging": {
    "mode": "file",
    "logDir": "/data/paperclip/logs"
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
      "baseDir": "/data/paperclip/storage"
    }
  },
  "secrets": {
    "provider": "local_encrypted",
    "strictMode": false,
    "localEncrypted": {
      "keyFilePath": "/data/paperclip/secrets/master.key"
    }
  }
}
EOF
  echo "Config generated at $CONFIG_PATH"
else
  echo "Using existing config at $CONFIG_PATH"
fi

echo "Starting Paperclip..."
exec paperclipai run --config "$CONFIG_PATH"
