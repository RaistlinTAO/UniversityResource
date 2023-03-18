#!/bin/bash

while true;
 highValue=$(bc <<< "scale=1;$RANDOM/32768*(7.4-4.4)+4.4")
 lowValue=$(bc <<< "scale=1;$RANDOM/32768*(3.7-1.0)+1.0")
 echo "Publish New Port Tide, High:" $highValue ", low: " $lowValue 
 do mosquitto_pub -h 192.168.203.100 -u roger -P password -m "{high: "$highValue", low: "$lowValue"}" -t port-tide;
 sleep 5;
done
