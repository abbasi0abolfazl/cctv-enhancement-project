#!/usr/bin/env bash
set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <path_to_input_video> [output_video]"
  echo "Example: $0 input_cctv.mp4 results/videos/video_people_focused.mp4"
  exit 1
fi

INPUT_VIDEO="$1"
OUTPUT_VIDEO="${2:-video_people_focused.mp4}"

if [ ! -f "$INPUT_VIDEO" ]; then
  echo "Error: Input file '$INPUT_VIDEO' does not exist."
  exit 1
fi

echo "Cropping and zooming into people..."
ffmpeg -y -i "$INPUT_VIDEO" \
  -vf "crop=480:680:380:180,scale=960:1360:flags=lanczos" \
  -c:v libx264 -crf 17 -preset fast -c:a copy "$OUTPUT_VIDEO"

echo "Done! Focused video saved to $OUTPUT_VIDEO"

