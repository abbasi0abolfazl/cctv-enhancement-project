#!/usr/bin/env bash
set -e

INPUT_VIDEO="${1:-/home/abolfazl/Downloads/video_2026-09-21_10-06-40.mp4}"
OUTPUT_VIDEO="${2:-video_enhanced_forensic.mp4}"

echo "Processing $INPUT_VIDEO -> $OUTPUT_VIDEO ..."
ffmpeg -y -i "$INPUT_VIDEO" \
  -vf "deblock=filter=weak:block=4,hqdn3d=1.5:1.5:4:4,cas=strength=0.7,eq=contrast=1.18:brightness=0.03:gamma=1.15:saturation=1.1" \
  -c:v libx264 -crf 17 -preset slow -c:a copy "$OUTPUT_VIDEO"

echo "Done! Output saved to $OUTPUT_VIDEO"
