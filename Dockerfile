FROM node:22-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    openssl \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Paperclip globally
RUN npm install -g paperclipai

# Create the full Paperclip home directory structure
ENV PAPERCLIP_HOME=/root/.paperclip
RUN mkdir -p $PAPERCLIP_HOME/instances/default/db \
    $PAPERCLIP_HOME/instances/default/logs \
    $PAPERCLIP_HOME/instances/default/data/backups \
    $PAPERCLIP_HOME/instances/default/data/storage \
    $PAPERCLIP_HOME/instances/default/secrets \
    $PAPERCLIP_HOME/instances/default/telemetry

# Copy all app files
COPY . /app/

# Copy config to the default Paperclip location
RUN cp /app/config.json $PAPERCLIP_HOME/instances/default/config.json

# Create .env with secrets (will be overridden by Railway env vars at runtime)
RUN echo "PAPERCLIP_AGENT_JWT_SECRET=$(openssl rand -hex 32)" > $PAPERCLIP_HOME/instances/default/.env && \
    echo "BETTER_AUTH_SECRET=$(openssl rand -base64 32)" >> $PAPERCLIP_HOME/instances/default/.env

# Create telemetry state
RUN echo '{"installId":"'$(cat /proc/sys/kernel/random/uuid)'","salt":"'$(openssl rand -hex 32)'","createdAt":"2026-04-14T00:00:00.000Z","firstSeenVersion":"2026.403.0"}' > $PAPERCLIP_HOME/instances/default/telemetry/state.json

EXPOSE 3100

# Run paperclipai without --config flag so it uses the default home path
CMD ["paperclipai", "run"]
