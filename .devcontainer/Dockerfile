FROM --platform=$BUILDPLATFORM ubuntu:24.04@sha256:4fbb8e6a8395de5a7550b33509421a2bafbc0aab6c06ba2cef9ebffbc7092d90

ARG TARGETOS
ARG TARGETARCH
ARG USERNAME=vscode
ARG USER_UID=1001
ARG USER_GID=${USER_UID}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash-completion \
        build-essential \
        ca-certificates \
        curl \
        git \
        libssl-dev \
        lldb \
        pkg-config \
        vim \
        sudo \
        ssh \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/ssh /etc/sudoers.d

RUN echo 'github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl' \
      >> /etc/ssh/ssh_known_hosts

RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} --shell /bin/bash \
    && echo "${USERNAME} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

RUN <<EOF
  curl -fsSL https://github.com/microsoft/apm/releases/latest/download/apm-linux-${TARGETARCH}.tar.gz | tar -xz -C /usr/local/lib/
  mv /usr/local/lib/apm-${TARGETOS}-${TARGETARCH} /usr/local/lib/apm
  ln -sf /usr/local/lib/apm/apm /usr/local/bin/apm
EOF
