#!/usr/bin/env bash

set -e

FILE="bootstrap.sh"

# Fix Windows line endings automatically if present
if file "$FILE" | grep -q CRLF; then
  echo "Fixing CRLF line endings in $FILE"
  sed -i 's/\r$//' "$FILE"
fi

chmod +x "$FILE"

exec bash "$FILE"