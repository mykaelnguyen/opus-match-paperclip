FROM node:22-slim

RUN apt-get update && apt-get install -y openssl ca-certificates curl && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Paperclip globally
RUN npm install -g paperclipai

# Cache bust to ensure latest files are always copied
ARG CACHEBUST=6
COPY . /app/

# Create a non-root user for Paperclip (Postgres refuses to run as root)
RUN groupadd -r paperclip && useradd -r -g paperclip -m -d /home/paperclip paperclip

# Create the /data/paperclip directory and give ownership to paperclip user
RUN mkdir -p /data/paperclip && chown -R paperclip:paperclip /data/paperclip /app /home/paperclip

# Make start script executable
RUN chmod +x /app/scripts/start.sh

# Switch to non-root user
USER paperclip

EXPOSE 3100

# Use start.sh which generates config at runtime with correct domain
CMD ["/bin/bash", "/app/scripts/start.sh"]
