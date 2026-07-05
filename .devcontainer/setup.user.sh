#!/bin/sh

mkdir -p ~/.local/bin

curl -fsSL \
  https://github.com/starship/starship/releases/download/v1.25.1/starship-x86_64-unknown-linux-musl.tar.gz \
  | tar xz -C ~/.local/bin
echo 'eval "$(~/.local/bin/starship init bash)"' >> ~/.bashrc
