# Technical Engineering Journal: CCTV Video & Facial Enhancement

**Date:** September 21, 2026  
**Subject:** Quality enhancement, edge sharpness, and facial clarity restoration in night surveillance footage (`video_2026-09-21_10-06-40.mp4`)  
**Project Path:** `/home/abolfazl/workSpace/devWorkspace/cctv-enhancement-project/`

---

## 1. Baseline Specifications & Input Image Analysis

- **Source File:** `video_2026-09-21_10-06-40.mp4`
- **Duration:** 15.3 seconds (458 frames at 30 fps)
- **Container Resolution:** 1080x1248 pixels (AVC/H.264 codec, ~8.6 Mbps bitrate)
- **Hardware Environment:** Linux OS with AMD Renoir APU (Radeon Vega Mobile graphics)
- **Optical Nature & Inherent Constraints:**
  - Footage captured by a surveillance camera (CCTV) in night conditions.
  - The frame is an **extreme digital crop/zoom** of the primary sensor, which has low native resolution.
  - The actual physical resolution of the subjects' heads and faces in the frame is under **15×15 pixels**.
  - High thermal sensor noise in dark regions, heavy macroblocking artifacts (8×8 compression blocks), and crushed shadows with poor dynamic range.

---

## 2. Formulation of Three Core Strategies

At the outset of the project, three engineering avenues were mapped out:
1. **Strategy 1 (Commercial AI Video Enhancers):** Off-the-shelf tools such as Topaz Video AI (Iris LQ model).
2. **Strategy 2 (Open-Source Face Restoration Models - CodeFormer + Real-ESRGAN):** Specialized deep face restoration models executed via Google Colab GPU runtimes.
3. **Strategy 3 (Mathematical Digital Signal Processing & Forensic Filters without AI):** Deterministic FFmpeg filter graphs to maximize forensic admissibility and prevent the generation of synthetic data.

---

## 3. Chronological Engineering Log

### Step 1: Executing Strategy 3 (Maximum Forensic Filtering with FFmpeg)
Per user request to push deterministic non-AI filtering to its limits, a 4-stage processing pipeline was engineered:
- **Deblocking (`deblock`):** Attenuated jagged 8×8 sensor/compression block boundaries.
- **Spatio-Temporal Denoising (`hqdn3d`):** Filtered sensor grain and dark-background flicker without blurring moving human subjects.
- **Contrast Adaptive Sharpening (`AMD CAS`):** Enhanced edge contrast along clothing and silhouettes without introducing white halos.
- **Levels & Gamma Equalization (`eq/gamma`):** Uncovered texture previously crushed within dark clothing shadows.
- **Output:** Produced `results/videos/video_enhanced_forensic.mp4`.
- **Finding & Limitation:** While the background was cleaned and silhouettes became sharper, the initial optics captured fewer than 15 pixels across each face. Pure deterministic DSP cannot synthesize missing optical photons (eyes, nose, eyebrows); subjective facial clarity showed negligible improvement.

---

### Step 2: Transition to Strategy 2 (Google Colab & CodeFormer Restoration)
To resolve facial features, a dedicated Google Colab notebook was built (`notebooks/CodeFormer_CCTV_Enhance.ipynb`). Two technical obstacles were identified and resolved:

1. **Colab Argument Syntax Error:**
   - Error: `inference_codeformer.py: error: unrecognized arguments: False`
   - Cause: The `--has_aligned` flag in `argparse` is a boolean flag (`action="store_true"`) and does not accept `False` as a string parameter. Omitting the flag for unaligned video frames resolved the failure.
2. **Face Detection Failure (No face detected):**
   - Automated face detection networks (RetinaFace) operating on the full 1080×1248 canvas look for faces larger than 60 pixels. Because faces occupied less than 15 pixels in a sub-region of the frame, the detector rejected them as background noise.

---

### Step 3: Generative AI Experimentation & User Feedback
To evaluate the absolute ceiling of visual resolution, deep generative AI restoration was applied to a selected frame (`results/images/enhanced_ai_frame.jpg`).
- **Result:** The image achieved dramatic high-frequency sharpness. However, to fill in the missing pixel data, the neural network "painted" entirely synthetic facial features.
- **User Feedback:**
  > *"You tried too hard to make it clear. It doesn't need to be so perfect that it looks fake; a few steps earlier is better so that the image is not fabricated."*
- **Engineering Decision:** Discontinue unconstrained generative diffusion (hallucinatory synthesis) and transition to fidelity-constrained restoration.

---

### Step 4: Engineering 3 Natural Intermediate Levels (Zero Hallucination)
To satisfy the requirement of an earlier, natural intermediate stage, multi-frame temporal stacking was implemented:
- Extracted a burst of 10 consecutive frames around second 8 using the `tmix` filter to cancel out stochastic Poisson noise.
- Applied bilateral anti-aliasing.
- Generated three progressive output levels without synthesizing any artificial pixels:
  - **Level 1 (`natural_enhancement_level1.jpg`):** Block artifact removal with 100% evidentiary authenticity.
  - **Level 2 (`natural_enhancement_level2.jpg`):** 10-frame stacking revealing true anatomical form of heads, hands, and bodies.
  - **Level 3 (`natural_enhancement_level3.jpg`):** Forensic structural sharpening without artificial feature generation.

---

### Step 5: Final Engineering Solution ("The Sweet Spot")
To reliably trigger CodeFormer's face detector without fabricating faces:
1. **Targeted Region-of-Interest (ROI) Zoom (`results/videos/video_people_focused.mp4`):**
   A 480×680 bounding window was cropped around the three subjects and upscaled with a 2x Lanczos filter to 960×1360. This enlarged the subjects' heads **4 to 5 times larger** relative to the frame.
2. **Fidelity Weight Anchoring ($w = 0.75$):**
   With the enlarged ROI, CodeFormer detects faces instantly. Setting the fidelity weight to $w = 0.75$ constrains the model to sharpen existing contours while preventing it from inventing a foreign persona.

---

## 4. Repository Structure & Deliverables

```text
/home/abolfazl/workSpace/devWorkspace/cctv-enhancement-project/
├── README.md                                 # Primary project documentation
├── JOURNAL.md                                # Engineering journal (English)
├── JOURNAL_FA.md                             # Engineering journal (Persian original)
├── notebooks/
│   ├── CodeFormer_CCTV_Enhance.ipynb         # Google Colab notebook (English)
│   └── CodeFormer_CCTV_Enhance_FA.ipynb      # Google Colab notebook (Persian)
├── scripts/
│   ├── 01_forensic_enhancement.sh            # Forensic DSP filter pipeline
│   ├── 02_crop_and_focus.sh                  # ROI cropping & 2x Lanczos super-sampling
│   ├── 03_multiframe_stacking.sh             # 10-frame burst temporal averaging
│   └── 04_extract_frames.sh                  # 1-FPS frame extraction utility
└── results/
    ├── videos/
    │   ├── video_enhanced_forensic.mp4       # Forensic DSP enhanced video
    │   └── video_people_focused.mp4          # Cropped, super-sampled video for CodeFormer
    └── images/
        ├── enhanced_ai_frame.jpg             # High-generation reference test (AI hallucination demo)
        ├── natural_enhancement_level1.jpg    # Level 1 authentic deblocked frame
        ├── natural_enhancement_level2.jpg    # Level 2 10-frame stacked frame
        ├── natural_enhancement_level3.jpg    # Level 3 forensic sharpened frame
        ├── natural_faces_closeup.jpg         # Closeup of natural faces without alteration
        └── cctv_frames/                      # Extracted 1-FPS frame series
```

---

## 5. Reproduction Guide

### Running Local Deterministic Filters:
```bash
cd /home/abolfazl/workSpace/devWorkspace/cctv-enhancement-project/scripts
./01_forensic_enhancement.sh input_video.mp4 results/videos/video_enhanced_forensic.mp4
```

### Preparing Video for Neural Restoration:
```bash
./02_crop_and_focus.sh input_video.mp4 results/videos/video_people_focused.mp4
```

### Execution Command in Google Colab (Fidelity Anchor $w = 0.75$):
```bash
!python inference_codeformer.py \
    -i "/content/CodeFormer/video_people_focused.mp4" \
    --bg_upsampler realesrgan \
    --face_upsample \
    -w 0.75
```
