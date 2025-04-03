ARG BASE_IMAGE="rockylinux"
ARG BASE_TAG="9"
FROM $BASE_IMAGE:$BASE_TAG

USER root

WORKDIR /opt/scripts

COPY . .

ARG IMAGE_USER=root

RUN <<EOF
  ./installs
  NVIM_INSTALL_USER=$IMAGE_USER ./neovim
  ./tmux
  ./liquidprompt
EOF

USER $IMAGE_USER

WORKDIR /

SHELL ["/bin/bash"]
