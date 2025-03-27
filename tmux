#!/bin/bash
function ubuntu() {
  sudo apt -y install tmux
}

function rhel() {
  sudo dnf -y install tmux
}

OS_ID_LIKE=$(. /etc/os-release && echo "$ID_LIKE")
OS_ID=$(. /etc/os-release && echo "$ID")
if [[ "$OS_ID_LIKE" =~ rhel ]]; then
  rhel
elif [[ "$OS_ID" =~ ubuntu ]]; then
  ubuntu
else
  echo "Got ID_LIB $OS_ID_LIKE and ID $OS_ID, but that isn't implemented"
  exit 1
fi

exit 0
