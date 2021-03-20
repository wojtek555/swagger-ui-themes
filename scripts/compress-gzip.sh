#!/usr/bin/env bash

# see https://certsimple.com/blog/nginx-brotli
# Compresses files with gzip

set -a

source "scripts/compress-env.sh"

compress_gzip() {

  START=$(($(date +%s%N)/1000000))
  # echo "$METHOD compression of $DESTINATION started"

  # echo "Deleting old gzip files in $DESTINATION recursively"
  find "$DESTINATION" -name "*.gz" -type f -delete

  # echo "Creating new gzip files in $DESTINATION recursively";

  # CMD='echo -ne "Compressing %\r"; gzip -cf "%" > "%.gz";'
  CMD='gzip -cf "%" > "%.gz";'

  find "$DESTINATION" -type f -size +1400c -regextype posix-extended \
      -regex "$HIGH_QUALITY_REGEX|$LOW_QUALITY_REGEX" |
    grep -v --extended-regexp --regexp="$NO_COMPRESSION_REGEX" |
    xargs --max-args=1 --max-procs=0 -I % \
    bash -c "$CMD"

  END=$(($(date +%s%N)/1000000))
  DIFF=$((END - START))
  echo "$METHOD compression of $DESTINATION done in $DIFF ms"

}

METHOD="gzip"
run_compression
