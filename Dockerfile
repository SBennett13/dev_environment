ARG BASE_IMAGE="rockylinux"
ARG BASE_TAG="9"
FROM $BASE_IMAGE:$BASE_TAG

USER root

WORKDIR /opt

COPY . .

RUN <<EOF
  ./neovim
  ./tmux
  ./liquidprompt
EOF

# ---------

WORKDIR /root
RUN <<EOF
  mkdir .local/share
  mkdir .cache
  mkdir .config
  git clone https://github.com/SBennett13/nvim.git .config/nvim
EOF

# Install config plugins
RUN <<EOF
  nvim --headless -c "+Lazy! sync" "+qa"
  nvim --headless -c "TSUpdate" "+qa"
EOF

SHELL ["/bin/bash"]
