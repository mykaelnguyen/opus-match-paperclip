#!/bin/bash
set -e

echo "=== Paperclip Railway Startup ==="
echo "Date: $(date)"

# Railway auto-injects RAILWAY_PUBLIC_DOMAIN
DOMAIN="${RAILWAY_PUBLIC_DOMAIN:-localhost:3100}"
if [ "$DOMAIN" = "localhost:3100" ]; then
  PUBLIC_URL="http://${DOMAIN}"
else
  PUBLIC_URL="https://${DOMAIN}"
fi
PORT="${PORT:-3100}"

echo "Domain: $DOMAIN"
echo "Public URL: $PUBLIC_URL"
echo "Port: $PORT"

# Create data directories at /data/paperclip (where Paperclip looks on Railway)
mkdir -p /data/paperclip/db \
         /data/paperclip/logs \
         /data/paperclip/data/backups \
         /data/paperclip/data/storage \
         /data/paperclip/secrets \
         /data/paperclip/telemetry

# Generate config.json with the correct domain
cat > /data/paperclip/config.json << CONFIGEOF
{
  "\$meta": {
    "version": 1,
    "updatedAt": "$(date -u +%Y-%m-%dT%H:%M:%S.000Z)",
    "source": "onboard"
  },
  "database": {
    "mode": "embedded-postgres",
    "embeddedPostgresDataDir": "/data/paperclip/db",
    "embeddedPostgresPort": 54329,
    "backup": {
      "enabled": true,
      "intervalMinutes": 60,
      "retentionDays": 30,
      "dir": "/data/paperclip/data/backups"
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
    "port": ${PORT},
    "publicUrl": "${PUBLIC_URL}",
    "allowedHostnames": ["${DOMAIN}"],
    "serveUi": true
  },
  "auth": {
    "baseUrlMode": "explicit",
    "publicBaseUrl": "${PUBLIC_URL}",
    "disableSignUp": false
  },
  "telemetry": {
    "enabled": true
  },
  "storage": {
    "provider": "local_disk",
    "localDisk": {
      "baseDir": "/data/paperclip/data/storage"
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
CONFIGEOF

echo "Config written to /data/paperclip/config.json"

# Generate .env if not exists
if [ ! -f /data/paperclip/.env ]; then
  echo "PAPERCLIP_AGENT_JWT_SECRET=$(openssl rand -hex 32)" > /data/paperclip/.env
  echo "BETTER_AUTH_SECRET=$(openssl rand -base64 32)" >> /data/paperclip/.env
  echo ".env created"
else
  echo ".env already exists"
fi

# Generate telemetry state if not exists
if [ ! -f /data/paperclip/telemetry/state.json ]; then
  echo "{\"installId\":\"$(cat /proc/sys/kernel/random/uuid)\",\"salt\":\"$(openssl rand -hex 32)\",\"createdAt\":\"2026-04-14T00:00:00.000Z\",\"firstSeenVersion\":\"2026.403.0\"}" > /data/paperclip/telemetry/state.json
  echo "telemetry state created"
fi

echo "=== Starting Paperclip ==="
exec paperclipai run
