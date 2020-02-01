#!/usr/bin/env bash -e

# This would stop focus.
# /usr/bin/open focus://unfocus

# Say with an Italian accent that the Pomodoro finished. 
/usr/bin/say --voice=Alice "Il pomodoro è finito."

# Turn off the display after a 10 seconds delay. 
sleep 10s
/usr/bin/pmset displaysleepnow
