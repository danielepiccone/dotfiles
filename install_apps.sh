#!/bin/sh
echo "Installing applications..."

if test "$(uname)" = "Darwin"; then
  echo "Missing implementation"
  exit 0
fi

if test "$(uname)" = "Linux"; then
  (cd ansible && ./provision.sh)
  exit 0
fi
