#!/usr/bin/env bash
set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <path_to_input_video> [output_image]"
  echo "Example: $0 input_cctv.mp4 results/images/stacked_frame.png"
  exit 1
fi

INPUT_VIDEO="$1"
OUTPUT_IMAGE="${2:-stacked_frame.png}"

if [ ! -f "$INPUT_VIDEO" ]; then
  echo "Error: Input file '$INPUT_VIDEO' does not exist."
  exit 1
fi

BURST_DIR="burst_temp_$$"
mkdir -p "$BURST_DIR"

# Ensure temporary directory is cleaned up upon script exit or error
trap 'rm -rf "$BURST_DIR"' EXIT

echo "Extracting 0.5s burst at second 8..."
ffmpeg -y -ss 00:00:07.8 -t 0.5 -i "$INPUT_VIDEO" \
  -vf "crop=450:600:400:200" "$BURST_DIR/frame_%02d.png"

echo "Applying temporal mixing across 10 successive frames..."
ffmpeg -y -i "$BURST_DIR/frame_%02d.png" \
  -vf "tmix=frames=10" "$BURST_DIR/stacked_%02d.png"

cp "$BURST_DIR/stacked_10.png" "$OUTPUT_IMAGE"

echo "Done! Temporal stacked frame saved to $OUTPUT_IMAGE"

