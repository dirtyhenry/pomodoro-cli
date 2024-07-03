#!/usr/bin/env bash 

set -e

# Check if exactly 4 arguments are provided
if [ "$#" -ne 4 ]; then
  echo "Usage: $0 arg1 arg2 arg3 arg4"
  exit 1
fi

# This would stop focus.
# /usr/bin/open focus://unfocus

# # Writing to SQLite databse
# DATABASE="database.sqlite"
# TABLE="pomodoros"

# # Create the table if it doesn't exist
# sqlite3 "$DATABASE" <<EOF
# CREATE TABLE IF NOT EXISTS $TABLE (
#   start_date TEXT,
#   end_date TEXT,
#   duration INTEGER,
#   message TEXT
# );
# EOF

# # Insert the 4 arguments into the table
# sqlite3 "$DATABASE" <<EOF
# INSERT INTO $TABLE (start_date, end_date, duration, message)
# VALUES ('$1', '$2', '$3', '$4');
# EOF

# Say with an Italian accent that the Pomodoro finished. 
/usr/bin/say --voice=Alice "Il pomodoro è finito."

# Turn off the display after a 10 seconds delay.
sleep 10
/usr/bin/pmset displaysleepnow
