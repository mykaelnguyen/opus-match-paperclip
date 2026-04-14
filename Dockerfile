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

# Create all data directories
RUN mkdir -p /data/paperclip/db \
    /data/paperclip/logs \
    /data/paperclip/backups \
    /data/paperclip/storage \
    /data/paperclip/secrets

# Copy config.json to the path Paperclip expects
COPY config.json /data/paperclip/config.json

# Also copy to the default Paperclip home location
RUN mkdir -p /root/.paperclip/instances/default && \
    cp /data/paperclip/config.json /root/.paperclip/instances/default/config.json

# Expose port
EXPOSE 3100

# Run Paperclip with explicit config path
CMD ["paperclipai", "run", "--config", "/data/paperclip/config.json"]
