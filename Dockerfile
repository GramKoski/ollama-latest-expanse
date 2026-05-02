FROM python:3.12-slim

ARG OLLAMA_VERSION=0.3.9

LABEL org.opencontainers.image.title="ollama-latest-expanse" \
      org.opencontainers.image.description="Ollama pinned for NVIDIA 525-series compatibility on SDSC Expanse" \
      org.opencontainers.image.source="https://github.com/GramKoski/ollama-latest-expanse"

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1 \
    OLLAMA_MODELS=/root/.ollama/models \
    OLLAMA_LLM_LIBRARY=cuda_v11

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash curl ca-certificates git jq procps pciutils \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L "https://github.com/ollama/ollama/releases/download/v${OLLAMA_VERSION}/ollama-linux-amd64.tgz" \
    | tar -xz -C /usr/local

COPY requirements.txt /tmp/requirements.txt

RUN python -m pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

EXPOSE 11434
VOLUME ["/root/.ollama"]

CMD ["/bin/bash"]

