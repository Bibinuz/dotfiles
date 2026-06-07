#!/bin/bash

URL=$1

if [ -z "$URL" ]; then
  echo "Error: No URL provided"
  exit 1
fi

nohup helium-browser --app="$URL"
