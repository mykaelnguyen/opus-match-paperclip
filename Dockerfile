FROM node:22-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    openssl \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install Paperclip globally
RUN npm install -g paperclipai

# Create data directories for persistent storage
RUN mkdir -p /data/paperclip/db \
    /data/paperclip/logs \
    /data/paperclip/backups \
    /data/paperclip/storage \
    /data/paperclip/secrets

# Copy all files including scripts
COPY . /app/

# Make startup script executable
RUN chmod +x /app/scripts/start.sh

# Expose port
EXPOSE 3100

# Use shell form CMD so Railway doesn't override it
CMD bash /app/scripts/start.sh
