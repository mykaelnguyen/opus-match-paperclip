FROM node:22-slim

RUN apt-get update && apt-get install -y openssl ca-certificates curl && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Paperclip globally
RUN npm install -g paperclipai

# Find and rename the real paperclipai binary, then install our wrapper
RUN REAL_BIN=$(which paperclipai) && \
    mv "$REAL_BIN" "${REAL_BIN}-real" && \
    echo "Real binary moved to: ${REAL_BIN}-real"

# Cache bust
ARG CACHEBUST=8
COPY . /app/

# Install wrapper as the paperclipai command
RUN REAL_BIN_DIR=$(dirname $(which paperclipai-real)) && \
    cp /app/scripts/paperclipai-wrapper.sh "${REAL_BIN_DIR}/paperclipai" && \
    chmod +x "${REAL_BIN_DIR}/paperclipai" && \
    # Update the wrapper to point to the correct real binary path
    sed -i "s|REAL_PAPERCLIPAI=.*|REAL_PAPERCLIPAI=\"${REAL_BIN_DIR}/paperclipai-real\"|" "${REAL_BIN_DIR}/paperclipai" && \
    echo "Wrapper installed at: ${REAL_BIN_DIR}/paperclipai"

# Create a non-root user for Paperclip (Postgres refuses to run as root)
RUN groupadd -r paperclip && useradd -r -g paperclip -m -d /home/paperclip paperclip

# Create the /data/paperclip directory and give ownership to paperclip user
RUN mkdir -p /data/paperclip && chown -R paperclip:paperclip /data/paperclip /app /home/paperclip

# Switch to non-root user
USER paperclip

EXPOSE 3100

# Railway will run "paperclipai run" which now hits our wrapper
CMD ["paperclipai", "run"]
