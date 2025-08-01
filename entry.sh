#!/bin/bash

HOST=${HOST:-"hdhomerun.local"}
FILENAME=${FILENAME:-"/output/epg.xml"}
DAYS=${DAYS:-"7"}
HOURS=${HOURS:-"4"}

echo "Starting EPG fetch loop (every 12 hours)"
while true; do
  echo "[$(date)] Running EPG fetch..."
  python HDHomeRunEPG_To_XmlTv.py \
    --host "$HOST" \
    --filename "$FILENAME" \
    --days "$DAYS" \
    --hours "$HOURS"

  echo "[$(date)] Done. Sleeping 12h..."
  sleep 43200
done
