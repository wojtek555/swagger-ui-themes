#!/usr/bin/env bash

# see https://certsimple.com/blog/nginx-brotli
# Compresses files with brotli

set -a

source "scripts/compress-env.sh"

compress_brotli() {

  START=$(($(date +%s%N)/1000000))
  # echo "$METHOD compression of $DESTINATION started"

  # echo "Deleting old br files in $DESTINATION recursively"
  find "$DESTINATION" -name "*.br" -type f -delete

  # echo "Creating new br files in $DESTINATION recursively";

  # CMD_HIGH_QUALITY='echo "Compressing %"; brotli --force --quality=11 --output="%.br" "%";'
  CMD_HIGH_QUALITY='brotli --force --quality=11 "%";'

  # CMD_LOW_QUALITY='echo "Compressing %"; brotli --force --quality=9 --output="%.br" "%";'
  CMD_LOW_QUALITY='brotli --force --quality=9 "%";'
  # CMD_LOW_QUALITY='echo "%";'

  find "$DESTINATION" -type f -size +1400c -regextype posix-extended -regex "$HIGH_QUALITY_REGEX" |
    grep -v --extended-regexp --regexp="$NO_COMPRESSION_REGEX|$LOW_QUALITY_REGEX" |
    xargs --max-args=1 --max-procs=0 -I % \
    bash -c "$CMD_HIGH_QUALITY"

  find "$DESTINATION" -type f -size +1400c -regextype posix-extended -regex "$LOW_QUALITY_REGEX" |
    xargs --max-args=1 --max-procs=0 -I % \
    bash -c "$CMD_LOW_QUALITY"

  END=$(($(date +%s%N)/1000000))
  DIFF=$((END - START))
  echo "$METHOD compression of $DESTINATION done in $DIFF ms"

}

METHOD="brotli"
run_compression
