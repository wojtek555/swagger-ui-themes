#!/usr/bin/env bash

if [ $# -eq 0 ]; then
  echo "No arguments provided, exiting"
  exit 1
fi

DESTINATION="${1%/}" # Strip ending slash.
NO_COMPRESSION_REGEX="index\.html$"
HIGH_QUALITY_REGEX="^.*\.html$|^.*\.css$|^.*\.js$|^.*\.json$|^.*\.markdown$|^.*\.md$|^.*\.txt$|^.*\.svg$|^.*\.yaml$|^.*\.yml$"
LOW_QUALITY_REGEX="^.*stats-es2015\.json$"
METHOD=

exists() {
  command -v "$1" >/dev/null 2>&1
}

run_compression() {
  # Find executable for method
  if exists "$METHOD"; then
    "compress_$METHOD"
  elif exists ./node_modules/.bin/gulp; then
    ./node_modules/.bin/gulp "compress-$METHOD" --dest="$DESTINATION"
  elif exists npx; then
    npx gulp "compress-$METHOD" --dest="$DESTINATION"
  elif exists gulp; then
    gulp "compress-$METHOD" --dest="$DESTINATION"
  else
    echo "Cannot find executable for $METHOD. Aborting."
    exit 1
  fi
}
