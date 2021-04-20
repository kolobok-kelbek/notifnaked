#!/bin/bash

prev=100;
percentage=72
low=0
normal=0
critical=0
die=0
full=0

while [ 1 = 1 ]
do
    percentage=$(upower -i $(upower -e | grep 'BAT') | grep -E "percentage" | grep -Eo "[0-9]{1,4}")

    if [ $percentage -lt $prev ]; then
        if [ $percentage -le 5 ] && [ $die -le 0 ]; then
            notify-send -u critical -i /usr/share/icons/Adwaita/scalable/status/battery-level-0-symbolic.svg "low battery $percentage%, charging required"
            die=1
        elif [ $percentage -le 15 ] && [ $percentage -gt 5 ] && [ $critical -le 0 ]; then
            notify-send -u critical -i /usr/share/icons/Adwaita/scalable/status/battery-level-0-symbolic.svg "low battery $percentage%, charging required"
            critical=1
        elif [ $percentage -le 30 ] && [ $percentage -gt 15 ] && [ $normal -eq 0 ]; then
            notify-send -u normal -i /usr/share/icons/Adwaita/scalable/status/battery-level-10-symbolic.svg "low battery $percentage%"
            normal=1
        elif [ $percentage -le 50 ] && [ $percentage -gt 30 ] && [ $low -eq 0 ]; then
            notify-send -u low -i /usr/share/icons/Adwaita/scalable/status/battery-level-50-charging-symbolic.svg "$percentage% battery"
            low=1
        elif [ $percentage -le 70 ] && [ $percentage -gt 50 ] && [ $full -eq 0 ]; then
            notify-send -u low -i /usr/share/icons/Adwaita/scalable/status/battery-level-50-charging-symbolic.svg "$percentage% battery"
            full=1
        fi;
    elif [ $percentage -gt $prev ]; then
        die=0
        low=0
        normal=0
        critical=0
        test=0
        full=0
    fi;

    prev=$percentage

    sleep 1s
done
