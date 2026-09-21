#!/usr/bin/env bash
set -e

INPUT_VIDEO="${1:-/home/abolfazl/Downloads/video_2026-09-21_10-06-40.mp4}"
BURST_DIR="burst_temp"
mkdir -p "$BURST_DIR"

echo "Extracting 0.5s burst at second 8..."
ffmpeg -y -ss 00:00:07.8 -t 0.5 -i "$INPUT_VIDEO" \
  -vf "crop=450:600:400:200" "$BURST_DIR/frame_%02d.png"

echo "Applying temporal mixing across 10 successive frames..."
ffmpeg -y -i "$BURST_DIR/frame_%02d.png" \
  -vf "tmix=frames=10" "$BURST_DIR/stacked_%02d.png"

cp "$BURST_DIR/stacked_10.png" stacked_frame.png
rm -rf "$BURST_DIR"

echo "Done! Temporal stacked frame saved to stacked_frame.png"
