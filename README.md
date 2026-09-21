# CCTV Video & Facial Enhancement Project

A comprehensive computer vision and forensic video processing toolkit for restoring low-resolution, degraded night CCTV/surveillance footage.

## 📌 Project Overview
This repository contains scripts, research, Google Colab notebooks, and forensic workflows developed to enhance blurry, heavily-pixelated surveillance footage without introducing artificial AI hallucinations (preserving true legal identities while maximizing clarity).

Detailed technical documentation and step-by-step engineering logs can be found in **[JOURNAL.md](JOURNAL.md)**.

---

## 📁 Repository Structure

```text
├── JOURNAL.md                                # Full engineering and forensic journal (in Persian)
├── README.md                                 # Project overview and instructions
├── notebooks/
│   └── CodeFormer_CCTV_Enhance.ipynb         # Google Colab notebook for CodeFormer + Real-ESRGAN
├── scripts/
│   ├── 01_forensic_enhancement.sh            # Mathematical forensic filters (Deblock, 3D denoise, CAS)
│   ├── 02_crop_and_focus.sh                  # Subject crop & 2x Lanczos super-sampling for face detection
│   ├── 03_multiframe_stacking.sh             # Multi-frame temporal averaging/stacking
│   └── 04_extract_frames.sh                  # 1-FPS frame extraction
└── results/
    ├── videos/                               # Enhanced video outputs
    └── images/                               # Sample frames, closeups, and comparison levels
```

---

## 🚀 Quick Start

### 1. Mathematical / Forensic Filtering (Option 3)
Removes sensor noise, macroblocking, and enhances local contrast without generative AI:
```bash
chmod +x scripts/*.sh
./scripts/01_forensic_enhancement.sh [path/to/video.mp4]
```

### 2. Pre-processing for Face Recognition / Restoration
Crops the surveillance frame directly onto subjects and upscales by 2x to guarantee face detector hits in deep learning frameworks:
```bash
./scripts/02_crop_and_focus.sh [path/to/video.mp4]
```

### 3. Google Colab AI Restoration (Option 2)
1. Open [Google Colab](https://colab.research.google.com).
2. Upload `notebooks/CodeFormer_CCTV_Enhance.ipynb`.
3. Enable GPU (`Runtime > Change runtime type > T4 GPU`).
4. Run all cells and upload the pre-focused video (`video_people_focused.mp4`).
5. Recommended fidelity weight: `-w 0.75` for natural clarity without identity distortion.

---

## 📜 License
MIT License
