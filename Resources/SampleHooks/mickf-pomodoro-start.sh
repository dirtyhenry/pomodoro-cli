#!/usr/bin/env bash

set -e

# Check if exactly 4 arguments are provided
if [ "$#" -ne 4 ]; then
	echo "Usage: $0 arg1 arg2 arg3 arg4"
	exit 1
fi

afplay ~/Documents/Private/Pop\ Culture/be-curious-not-judgemental.mp3
