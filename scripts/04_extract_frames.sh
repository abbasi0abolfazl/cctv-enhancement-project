#!/usr/bin/env bash
set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <path_to_input_video> [output_dir]"
  echo "Example: $0 input_cctv.mp4 results/images/cctv_frames"
  exit 1
fi

INPUT_VIDEO="$1"
OUT_DIR="${2:-cctv_frames}"

if [ ! -f "$INPUT_VIDEO" ]; then
  echo "Error: Input file '$INPUT_VIDEO' does not exist."
  exit 1
fi

mkdir -p "$OUT_DIR"

echo "Extracting 1 fps frames..."
ffmpeg -y -i "$INPUT_VIDEO" -vf "fps=1" "$OUT_DIR/frame_%02d.jpg"
echo "Done! Frames extracted to $OUT_DIR"

