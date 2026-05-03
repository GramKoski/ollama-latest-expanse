FROM python:3.12-slim

LABEL org.opencontainers.image.title="ollama-latest-expanse" \
      org.opencontainers.image.description="Latest Ollama for SDSC Expanse testing" \
      org.opencontainers.image.source="https://github.com/gramkoski/ollama-latest-expanse"

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1 

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash curl ca-certificates git jq procps pciutils zstd gnupg \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g opencode-ai@latest && \
    npm cache clean --force

RUN curl -fsSL https://ollama.com/download/ollama-linux-amd64.tar.zst \
    | tar --zstd -x -C /usr/local

COPY requirements.txt /tmp/requirements.txt

RUN python -m pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

RUN node --version && npm --version && opencode --version

CMD ["/bin/bash"]
