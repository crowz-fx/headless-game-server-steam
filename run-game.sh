#!/bin/bash

if [ -z "$GAME_RUN_COMMAND" ]; then
  echo "you need to supply the GAME_RUN_COMMAND env variable!"
  exit 1;
fi

# a restarted (not recreated) container keeps /tmp, and a stale lock pushes Xwayland off :0
rm -f /tmp/.X0-lock /tmp/.X11-unix/X0

weston --xwayland -B headless &

# mandatory, need weston to be up and in place before game starts
sleep "${SLEEP_TIME:-10}"

eval "$GAME_RUN_COMMAND"
