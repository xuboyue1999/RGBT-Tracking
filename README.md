# RGBT-Tracking
This repository contains the necessary tools for RGBT tracking, including datasets（GTOT, RGBT234, LasHeR）, evaluation tools, visualization tools, and results of existing works.

## Datasets

### 🌟GTOT

This dataset is derived from the paper "Learning Collaborative Sparse Representation for Grayscale-thermal Tracking" published in 2016 IEEE Transactions on Image Processing (T-IP) by Li et al. from the research group led by Professor Chenglong Li at Anhui University.

The dataset comprises 50 video pairs consisting of sequences of grayscale and thermal infrared images, with each pair having statistical bias. Additionally, the dataset includes ground truth annotations for each frame of the videos and two evaluation metrics.

For more information about the dataset and to download it, please visit [gtot.md](https://github.com/xuboyue1999/RGBT-Tracking/blob/main/datasets/GTOT/gtot.md)

![image](datasets/GTOT/overview.png) 


### 🌟RGBT234

This dataset is from the paper "RGB-T Object Tracking: Benchmark and Baseline" published in 2019 Pattern Recognition (PR) by Li et al. from the research group led by Professor Chenglong Li at Anhui University.

Key features of the dataset include:

The dataset comprises 234 pairs of RGB-T video sequences along with their corresponding ground truth annotations (GroundTruth).
The video sequences are labeled with 12 attributes.
The total number of frames in the dataset is 234,000, with the longest video sequence containing 8,000 frames.

For more information about the dataset and to download it, please visit [rgbt234.md](https://github.com/xuboyue1999/RGBT-Tracking/blob/main/datasets/RGBT234/rgbt234.md)

![image](datasets/RGBT234/overview.png) 


### 🌟LasHeR

LasHeR consists of 1224 visible and thermal infrared video pairs with more than 730K frame pairs in total. Each frame pair is spatially aligned and manually annotated with a bounding box, making the dataset well and densely annotated. LasHeR is highly diverse capturing from a broad range of object categories, camera viewpoints, scene complexities and environmental factors across seasons, weathers, day and night. Induced by real-world applications, several new challenges are take into consideration in data creation.

For more information about the dataset and to download it, please visit [lasher.md](https://github.com/xuboyue1999/RGBT-Tracking/blob/main/datasets/LasHeR/LasHeR.md)

![image](datasets/LasHeR//overview.png) 
