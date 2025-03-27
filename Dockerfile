FROM rockylinux:9

USER root

# Enable CodeReady Builders
RUN <<EOF
  dnf -y update
  dnf -y install yum-utils
  dnf config-manager --set-enabled crb
  dnf -y install cmake make git wget ninja-build gcc gettext glibc-gconv-extra unzip npm readline-devel
  dnf clean all
EOF

# Note about installs:
#   npm is for treesitter
#   readline-devel is for building lua
#   cmake -> glibc-gconv-extra is for building neovim
#   unzip is recommended in LazyHealth

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /opt

RUN <<EOF
  wget -qO- https://github.com/neovim/neovim/archive/refs/tags/v0.10.4.tar.gz | tar zx
EOF

WORKDIR /opt/neovim-0.10.4

RUN <<EOF
  make CMAKE_BUILD_TYPE=RelWithDebInfo
  make install
EOF

# lua
WORKDIR /opt
RUN wget -qO- https://www.lua.org/ftp/lua-5.1.tar.gz | tar zx

WORKDIR /opt/lua-5.1
RUN make linux && make install

# luarocks (Lua's package manager)
WORKDIR /opt
RUN <<EOF
  dnf -y install ncurses-devel libevent-devel readline-devel
  dnf clean all
  wget -qO- https://luarocks.org/releases/luarocks-3.11.1.tar.gz | tar zx
EOF

WORKDIR /opt/luarocks-3.11.1
RUN <<EOF
  ./configure && make && make install
EOF

# Install fd
RUN <<EOF
  dnf -y copr enable tkbcopr/fd
  dnf -y install fd
  dnf clean all
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
RUN ["nvim", "--headless", "-c", "\"+Lazy! sync\"", "+qa"]

SHELL ["/bin/bash"]
