#!/usr/bin/env bash
set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <path_to_input_video> [output_video]"
  echo "Example: $0 input_cctv.mp4 results/videos/video_enhanced_forensic.mp4"
  exit 1
fi

INPUT_VIDEO="$1"
OUTPUT_VIDEO="${2:-video_enhanced_forensic.mp4}"

if [ ! -f "$INPUT_VIDEO" ]; then
  echo "Error: Input file '$INPUT_VIDEO' does not exist."
  exit 1
fi

echo "Processing $INPUT_VIDEO -> $OUTPUT_VIDEO ..."
ffmpeg -y -i "$INPUT_VIDEO" \
  -vf "deblock=filter=weak:block=4,hqdn3d=1.5:1.5:4:4,cas=strength=0.7,eq=contrast=1.18:brightness=0.03:gamma=1.15:saturation=1.1" \
  -c:v libx264 -crf 17 -preset slow -c:a copy "$OUTPUT_VIDEO"

echo "Done! Output saved to $OUTPUT_VIDEO"

