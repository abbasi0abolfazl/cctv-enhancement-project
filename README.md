# CCTV Video & Facial Enhancement Project

A computer vision and forensic video processing toolkit engineered to restore degraded, low-resolution night surveillance (CCTV) footage while preserving factual identity and forensic admissibility.

---

## About This Project

### 1. Problem Statement & Background
Surveillance cameras operating in low-light night conditions face severe optical and digital constraints:
* **Severe Digital Zoom:** Cameras often capture wide fields of view; zooming into subjects leaves faces with fewer than **15×15 pixels** of spatial information.
* **Thermal & Sensor Noise:** High ISO gain introduces heavy chromatic and luminance noise across dark frames.
* **Compression Macroblocking:** H.264/AVC compression artifacts (8×8 and 16×16 blocks) obscure facial contours and edges.
* **Limited Dynamic Range:** Shadowed areas lose gradient details, making subjects appear as dark silhouettes.

### 2. The Core Dilemma: Legal Evidence vs. AI Hallucination
* **Pure Generative AI (Over-restoration):** Modern generative models (e.g., standard diffusion or aggressive GANs) attempt to create high-resolution imagery by hallucinating fine features. While visually sharp, they "invent" new facial features (eyes, nose, mouth) that do not belong to the actual suspect/person, rendering the material legally invalid and misleading.
* **Pure Mathematical Filtering (Under-restoration):** Traditional DSP filters (deblocking, contrast stretching, bilateral filtering) maintain 100% forensic authenticity, but cannot synthesize missing optical information if the initial sensor captured insufficient photons.

### 3. The Balanced Hybrid Solution (The "Sweet Spot")
This project establishes a four-stage hybrid pipeline balancing forensic authenticity with state-of-the-art super-resolution:
1. **Mathematical Forensic Denoising & Deblocking (FFmpeg):** Cleans sensor grain and macroblocking without introducing synthetic data.
2. **Multi-Frame Temporal Stacking (tmix):** Combines consecutive video frames across time to eliminate random noise while compounding authentic static subject details.
3. **Region-of-Interest (ROI) Super-Sampling:** Crops directly around subjects and performs Lanczos interpolation ($2\times$) to scale faces from sub-detectable sizes ($<15\text{px}$) to dimensions recognized by deep learning facial detectors ($>60\text{px}$).
4. **Controlled High-Fidelity Neural Restoration (CodeFormer + Real-ESRGAN):** Operates on Google Colab with an anchor fidelity setting ($w = 0.75$). This forces the network to enhance only authentic structural features rather than generating an entirely fictional persona.

---

## Repository Structure

```text
├── README.md                                 # Project documentation and guide
├── JOURNAL.md                                # Detailed engineering logs and research history (Persian)
├── notebooks/
│   └── CodeFormer_CCTV_Enhance.ipynb         # GPU-accelerated Google Colab workflow
├── scripts/
│   ├── 01_forensic_enhancement.sh            # Mathematical forensic filter chain (deblock, hqdn3d, CAS, eq)
│   ├── 02_crop_and_focus.sh                  # Subject crop & 2x Lanczos super-sampling for face detectors
│   ├── 03_multiframe_stacking.sh             # 10-frame temporal stacking filter
│   └── 04_extract_frames.sh                  # 1-FPS frame extraction utility
└── results/
    ├── videos/
    │   ├── video_enhanced_forensic.mp4       # 100% mathematical forensic enhancement output
    │   └── video_people_focused.mp4          # Cropped, super-sampled video ready for neural restoration
    └── images/
        ├── enhanced_ai_frame.jpg             # High-generation reference test (demonstrating AI hallucination)
        ├── natural_enhancement_level1.jpg    # Deblocked authentic frame
        ├── natural_enhancement_level2.jpg    # Multi-frame stacked result (10 frames)
        ├── natural_enhancement_level3.jpg    # Structurally sharpened forensic frame
        ├── natural_faces_closeup.jpg         # Closeup of natural faces without distortion
        └── cctv_frames/                      # Extracted frame sequences (1 frame/sec)
```

---

## Usage Guide

### Prerequisites
* **FFmpeg** (with `libx264`, `hqdn3d`, and `cas` filter support)
* **Google Colab** (or a local CUDA GPU for neural restoration)

### Step 1: Pure Forensic Enhancement (No AI Hallucinations)
Applies 3D spatial-temporal denoising, 8x8 deblocking, AMD FidelityFX CAS adaptive contrast sharpening, and gamma curve enhancement:
```bash
./scripts/01_forensic_enhancement.sh input_video.mp4 results/videos/video_enhanced_forensic.mp4
```

### Step 2: Pre-process Video for Neural Restoration
Crops the frame to the bounding region of interest and performs a 2x Lanczos upscale so that face detectors (RetinaFace) can lock onto targets:
```bash
./scripts/02_crop_and_focus.sh input_video.mp4 results/videos/video_people_focused.mp4
```

### Step 3: Multi-Frame Temporal Stacking (Still Frames)
Extracts a burst of consecutive frames and temporally averages them to reduce Poisson noise:
```bash
./scripts/03_multiframe_stacking.sh input_video.mp4 results/images/stacked_frame.png
```

### Step 4: Neural Restoration via Google Colab
1. Open [Google Colab](https://colab.research.google.com).
2. Upload `notebooks/CodeFormer_CCTV_Enhance.ipynb`.
3. Switch runtime to GPU: **Runtime > Change runtime type > T4 GPU**.
4. Run cells sequentially and upload the focused video (`video_people_focused.mp4`).
5. The notebook applies CodeFormer with fidelity weight `-w 0.75` and Real-ESRGAN background upsampling, then downloads the output video.

---

## Restoration Levels Comparison

| Level | Method | Hallucination Risk | Primary Use Case |
| :--- | :--- | :--- | :--- |
| **Level 1** | Deblock + 3D Denoise | 0% (None) | Direct courtroom evidence, preserving exact pixel values |
| **Level 2** | Multi-Frame Temporal Stacking | 0% (None) | Maximizing SNR without modifying optical geometry |
| **Level 3** | Adaptive Contrast Sharpening (CAS) | 0% (None) | Revealing silhouettes, clothing patterns, physical posture |
| **Level 4** | Controlled Neural Super-Res ($w=0.75$) | Very Low | Reconstructing facial contours while retaining true identity |
| **Full AI** | Pure Generative Diffusion ($w < 0.3$) | High (Hallucinates) | Artistic conceptualization only; not forensically sound |

---

## Documentation & Journal
For the complete technical development log, step-by-step experiment records, and Persian documentation, see **[JOURNAL.md](JOURNAL.md)**.

## License
This project is released under the [MIT License](LICENSE).
