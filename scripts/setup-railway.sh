#!/bin/bash
# Opus Match AI — Paperclip Railway Setup Script
# Run this once after first deployment to import the company config

set -e

PAPERCLIP_URL="${PAPERCLIP_URL:-http://localhost:3100}"
EXPORT_DIR="./company-export"

echo "=== Opus Match AI — Paperclip Setup ==="
echo "Target: $PAPERCLIP_URL"
echo ""

# Wait for server to be healthy
echo "Waiting for Paperclip server..."
until curl -sf "$PAPERCLIP_URL/api/health" > /dev/null 2>&1; do
  echo "  Server not ready, retrying in 5s..."
  sleep 5
done
echo "Server is healthy!"
echo ""

# Import company
echo "Importing Opus Match AI company config..."
paperclipai company import "$EXPORT_DIR" --url "$PAPERCLIP_URL"
echo "Import complete!"
echo ""
echo "=== Setup Complete ==="
echo "Visit $PAPERCLIP_URL to access your Paperclip instance."
echo "Use the board-claim URL from the server logs to claim admin ownership."
