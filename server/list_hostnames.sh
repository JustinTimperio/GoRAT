#!/usr/bin/env bash

cat /tmp/goRat/Control_Ports | cut -d ':' -f 2 | while read port; do
  echo "$(curl -s localhost:$port/fs/etc/hostname) = $port"
done
