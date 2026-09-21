#!/usr/bin/env bash
set -e

INPUT_VIDEO="${1:-/home/abolfazl/Downloads/video_2026-09-21_10-06-40.mp4}"
OUTPUT_VIDEO="${2:-video_people_focused.mp4}"

echo "Cropping and zooming into people..."
ffmpeg -y -i "$INPUT_VIDEO" \
  -vf "crop=480:680:380:180,scale=960:1360:flags=lanczos" \
  -c:v libx264 -crf 17 -preset fast -c:a copy "$OUTPUT_VIDEO"

echo "Done! Focused video saved to $OUTPUT_VIDEO"
