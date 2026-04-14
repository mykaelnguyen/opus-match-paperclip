FROM node:22-slim

RUN apt-get update && apt-get install -y openssl ca-certificates curl && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Paperclip globally
RUN npm install -g paperclipai

# Cache bust to ensure latest files are always copied
ARG CACHEBUST=5
COPY . /app/

# Create a non-root user for Paperclip (Postgres refuses to run as root)
RUN groupadd -r paperclip && useradd -r -g paperclip -m -d /home/paperclip paperclip

# Create the /data/paperclip directory structure
RUN mkdir -p /data/paperclip/db \
    /data/paperclip/logs \
    /data/paperclip/data/backups \
    /data/paperclip/data/storage \
    /data/paperclip/secrets \
    /data/paperclip/telemetry

# Copy config to /data/paperclip/
RUN cp /app/config.json /data/paperclip/config.json

# Create .env with secrets
RUN echo "PAPERCLIP_AGENT_JWT_SECRET=$(openssl rand -hex 32)" > /data/paperclip/.env && \
    echo "BETTER_AUTH_SECRET=$(openssl rand -base64 32)" >> /data/paperclip/.env

# Create telemetry state
RUN echo '{"installId":"'$(cat /proc/sys/kernel/random/uuid)'","salt":"'$(openssl rand -hex 32)'","createdAt":"2026-04-14T00:00:00.000Z","firstSeenVersion":"2026.403.0"}' > /data/paperclip/telemetry/state.json

# Set ownership of all data dirs to the paperclip user
RUN chown -R paperclip:paperclip /data/paperclip /app /home/paperclip

# Switch to non-root user
USER paperclip

EXPOSE 3100

CMD ["paperclipai", "run"]
