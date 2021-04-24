#!/bin/bash

prev_percentage=100
percentage=72

die=0
critical=0
low=0
middle=0
high=0

if [ -z $BATNOT_ICONS_PATH ]; then
      icons_path=$BATNOT_ICONS_PATH
else
      icons_path=/usr/share/icons/batnot
fi

icon_low_level=$BATNOT_ICONS_PATH/low-level.svg
icon_middle_level=$BATNOT_ICONS_PATH/middle-level.svg
icon_high_level=$BATNOT_ICONS_PATH/high-level.svg

while [ 1 = 1 ]
do
    percentage=$(upower -i $(upower -e | grep 'BAT') | grep -E "percentage" | grep -Eo "[0-9]{1,4}")

    if [ $percentage -lt $prev_percentage ]; then
        if [ $percentage -le 5 ] && [ $die -le 0 ]; then
            notify-send -u critical -i $icon_low_level "Low battery $percentage%, charging required"
            die=1
        elif [ $percentage -le 15 ] && [ $percentage -gt 5 ] && [ $critical -le 0 ]; then
            notify-send -u critical -i $icon_low_level "Low battery $percentage%, charging required"
            critical=1
        elif [ $percentage -le 30 ] && [ $percentage -gt 15 ] && [ $low -eq 0 ]; then
            notify-send -u normal -i $icon_middle_level "Low battery $percentage%"
            low=1
        elif [ $percentage -le 50 ] && [ $percentage -gt 30 ] && [ $middle -eq 0 ]; then
            notify-send -u low -i $icon_high_level "$percentage% battery"
            middle=1
        elif [ $percentage -le 70 ] && [ $percentage -gt 50 ] && [ $high -eq 0 ]; then
            notify-send -u low -i $icon_high_level "$percentage% battery"
            high=1
        fi;
    elif [ $percentage -gt $prev_percentage ]; then
        die=0
        critical=0
        low=0
        middle=0
        high=0
    fi;

    prev_percentage=$percentage

    sleep 1s
done
