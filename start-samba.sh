#!/usr/bin/env sh

if adduser -D $USERNAME; then
  (echo $PASSWORD; echo $PASSWORD) | smbpasswd -s -a $USERNAME
fi

smbd --foreground --log-stdout
