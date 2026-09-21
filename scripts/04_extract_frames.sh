#!/usr/bin/env bash
set -e

INPUT_VIDEO="${1:-/home/abolfazl/Downloads/video_2026-09-21_10-06-40.mp4}"
OUT_DIR="${2:-cctv_frames}"
mkdir -p "$OUT_DIR"

echo "Extracting 1 fps frames..."
ffmpeg -y -i "$INPUT_VIDEO" -vf "fps=1" "$OUT_DIR/frame_%02d.jpg"
echo "Done! Frames extracted to $OUT_DIR"
