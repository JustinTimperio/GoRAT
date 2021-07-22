#!/usr/bin/env bash

cat /tmp/goRAT/Control_Ports | cut -d ':' -f 2 | while read port; do
  echo $(curl -s localhost:$port/fs/etc/hostname) = "$port","$(echo "$port + 1" | bc)"
done
