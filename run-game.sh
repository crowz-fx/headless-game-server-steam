#!/bin/bash

if [ -z "$GAME_RUN_COMMAND" ]; then
  echo "you need to supply the GAME_RUN_COMMAND env variable!"
  exit 1;
fi

weston --xwayland -B headless &

# mandatory, need weston to be up and in place before game starts
sleep $SLEEP_TIME

eval $GAME_RUN_COMMAND
