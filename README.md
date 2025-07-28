# Code for: "Long-range organization of primary intestinal fibroblasts guides directed and persistent migration of organoid-derived intestinal epithelia"

This repository contains the MATLAB scripts used to process and analyze experimental data in the above manuscript. The study investigates how fibroblasts guide the directed migration of intestinal epithelial monolayers using a compartmentalized in vitro model. The scripts correspond to various types of data analyses, including trajectory analysis, vector alignment, topological defects, and velocity profile extraction.

## Repository structure

### `/crypt_villus.m`
Processes Excel sheets containing cell migration trajectories across the crypt–villus axis. It:
- Reads tracking data from multiple sheets.
- Standardizes all positions using the centroid of the crypt as origin.
- Separates and stores data from crypt, TA, and villus regions.
- Plots standardized trajectories for visualization.

### `/cell_trajectories.m`
Processes raw cell trajectory data to extract:
- Net displacement
- Total path length
- Directionality index
- Initial position relative to leading edge
- Angular persistence and MSD
- Fits a persistent random walk model to MSD data
- Outputs all measurements to Excel for downstream analysis

### `/defects.m`
Identifies topological defects in nematic orientation fields derived from cell alignment angles:
- Filters data based on elongation and coherence metrics
- Computes gradients and eigenvalues of orientation fields
- Classifies local topological defects
- Visualizes the distribution of defects across the field

### `/cell-coorientation.m`
Generates heatmaps and comparative angular statistics between epithelial cells and mesenchymal fibroblasts:
- Filters and grids alignment data
- Computes average and standard deviation of angles
- Computes cosine similarity between angle maps
- Saves comparison metrics and plots heatmap of alignment correlation

### `/PIV_veocity_profile.m`
Processes PIV (Particle Image Velocimetry) data to extract velocity profiles:
- Grids and averages x and y velocity components
- Exports mean and standard deviation profiles for plotting and statistical analysis

## Dependencies

- MATLAB R2021a or later (not strictly required, but tested with this version)
- `xlsread`, `writematrix`, `griddata`, and basic plotting functions
- Tracking data must be in `.xlsx` or `.csv` format with consistent structure

## Input Data Format

Tracking files must include columns such as:
- `track_ID`, `time`, `x`, `y`, `orientation_angle`, `coherence`, `elongation`, etc.

Data is assumed to be preprocessed with Fiji/MTrackJ or equivalent tools.
