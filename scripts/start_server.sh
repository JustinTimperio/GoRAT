#!/bin/bash

base_dl="/tmp/goRAT"
ssh_ports="/tmp/goRAT/SSH_Ports"
control_ports="/tmp/goRAT/Control_Ports"
tmp="0"

rm -rf $base_dl
mkdir -p $base_dl
touch $ssh_ports
touch $control_ports

echo 'Starting Chisel Server on Port 1337'
./chisel_1.7.6 server -p 1337 -v --reverse 2>&1 |

while read -r line
  do
    if echo "$line" | grep -q "Listening"; then
            if echo "$line" | grep -q 'session'; then
                    port=$(echo "$line" | grep "Listening" | cut -d':' -f 7 | cut -d'=' -f 1)
                    session=$(echo "$line" | cut -d'#' -f2 | cut -d':' -f1)
                    val=$(echo "$tmp + 1" | bc)

                    if [ "$val" -ne "$port" ]; then
                      first_port=$port
                      second_port=$(echo "$port + 1" | bc)

                      echo "============================================="
                      echo "Session #$session | Control Server Mounted On: $first_port"
                      echo "Session $session : $first_port" >> "$control_ports"
                      echo "Session #$session | SSH Server Mounted On: $second_port"
                      echo "Session $session : $second_port" >> "$ssh_ports"
                    fi

                    tmp="$port"
            fi
    fi

    if echo "$line" | grep -q "Closed connection"; then
            if echo "$line" | grep -q "session"; then
                    session=$(echo "$line" | cut -d'#' -f2 | cut -d':' -f1)

                    echo "============================================="
                    echo "Session #$session | Closed Connection on Two Ports"
                    grep -v "Session $session" $ssh_ports > $ssh_ports.tmp
                    mv $ssh_ports.tmp $ssh_ports
                    grep -v "Session $session" $control_ports > $control_ports.tmp
                    mv $control_ports.tmp $control_ports
            fi
    fi
done
