FROM ubuntu:18.04 AS base

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV FLASK_ENV=production
ENV FLASK_RUN_PORT=5000

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    build-essential \
    curl \
    git \
    subversion \
    sysvinit-utils tar \
    sudo \
    vim \
    binutils=2.31.1-16 \
    binutils-common=2.31.1-16 && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    python3.9 \
    python3.9-venv \
    python3.9-dev \
    python3-pip && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1 && \
    update-alternatives --install /usr/bin/pip3 pip3 /usr/bin/pip3 1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN python3 --version
RUN pip3 --version
RUN git --version
RUN ld --version | head -n1

WORKDIR /app

COPY requirements.txt .

RUN pip3 install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE ${FLASK_RUN_PORT}

CMD ["gunicorn", "-w", "2", "--bind", "0.0.0.0:${FLASK_RUN_PORT}", "app:app"]

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:${FLASK_RUN_PORT}/health || exit 1
