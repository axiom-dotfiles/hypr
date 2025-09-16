#!/usr/bin/env bash

function notify_brightness() {
  CURRENT_BRIGHTNESS=$(ddcutil getvcp 10 | awk -F'=' '/current/{print $2}' | sed 's/[^0-9]//g') 

  # if $2 exists, do not send notification
  if [[ "$2" == "--silent" ]]; then
    return
  fi
  notify-send -a "Brightness" -u low -i display-brightness-symbolic -h int:value:"${CURRENT_BRIGHTNESS%.*}" "Brightness: ${CURRENT_BRIGHTNESS%.*}%"
}

if [[ "$#" != 1 && "$#" != 2 && "$#" != 3 ]]; then
  echo "$#"
  printf "Usage: %s [inc|dec] [--silent] [--double|--triple]\n" "$0" >&2
  exit 1
fi


if ! command -v ddcutil &> /dev/null; then
  echo "Error: ddcutil is not installed. Please install it." >&2
  exit 1
fi

if [[ "$3" == "--double" ]]; then
  echo "Increasing brightness by 50"
  increment=50
elif [[ "$3" == "--triple" ]]; then
  echo "Increasing brightness by 75"
  increment=75
else
  echo "Increasing brightness by 25"
  increment=25
fi

if [[ "$1" == "inc" ]]; then
  current_brightness=$(ddcutil getvcp 10 | awk -F'=' '/current/{print $2}' | sed 's/[^0-9]//g')
  if (( current_brightness >= 100 )); then
    exit 0
  fi
  target_brightness=$((current_brightness + increment))
  if (( target_brightness > 100 )); then
    target_brightness=100
  fi
  ddcutil -d 1 setvcp 0x10 $target_brightness &> /dev/null
  ddcutil -d 2 setvcp 0x10 $target_brightness &> /dev/null
  notify_brightness "$@"
elif [[ "$1" == "dec" ]]; then
  echo "Decreasing brightness"
  current_brightness=$(ddcutil getvcp 10 | awk -F'=' '/current/{print $2}' | sed 's/[^0-9]//g')
  target_brightness=$((current_brightness - increment))
  if (( target_brightness < 0 )); then
    target_brightness=0
  fi
  ddcutil -d 1 setvcp 0x10 $target_brightness &> /dev/null
  ddcutil -d 2 setvcp 0x10 $target_brightness &> /dev/null
  notify_brightness "$@"
fi
