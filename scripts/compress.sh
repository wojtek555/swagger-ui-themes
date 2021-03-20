#!/usr/bin/env bash

if [ $# -eq 0 ]; then
  echo "No arguments provided, exiting"
  exit 1
fi

PROJECT=$1

compress_project() {
  # We are running processes in background.
  scripts/compress-brotli.sh dist/"$PROJECT" &
  scripts/compress-gzip.sh dist/"$PROJECT" &
  wait
}

echo "Starting compression of project $PROJECT"
echo ""
compress_project
echo ""
echo "Compression of project $PROJECT done"
