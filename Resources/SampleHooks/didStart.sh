#!/usr/bin/env bash 

set -e

# Check if exactly 4 arguments are provided
if [ "$#" -ne 4 ]; then
  echo "Usage: $0 arg1 arg2 arg3 arg4"
  exit 1
fi

# This would start focus
# /usr/bin/open focus://focus

# Invite to do some great job with an Italian accent.
/usr/bin/say --voice=Alice "Go ! Andiamo a lavorare."
