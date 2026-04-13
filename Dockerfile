FROM node:22-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    openssl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install Paperclip globally
RUN npm install -g paperclipai

# Create data directory for persistent storage
RUN mkdir -p /data/paperclip

# Expose port
EXPOSE 3100

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:3100/api/health || exit 1

# Start Paperclip
CMD ["paperclipai", "run", "--config", "/data/paperclip/config.json"]
