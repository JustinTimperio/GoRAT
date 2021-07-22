#!/usr/bin/env bash

cat /tmp/goRAT/Control_Ports | cut -d ':' -f 2 | while read port; do
  curl -s localhost:$port/hardware
done
