
##We use LaSOT_Evaluation_Toolkit to evaluate the performance of the RGBT tracking methods on LasHeR.

## LaSOT_Evaluation_Toolkit

This toolkit is utilized for evaluating trackers' performance on a large-scale benchmark LaSOT (http://vision.cs.stonybrook.edu/~lasot/).

## Usage
* Download the evaluation toolkit at http://vision.cs.stonybrook.edu/~lasot/results.html, unzip it to your computer
* Run `run_tracker_performance_evaluation.m` in Matlab

## Notes
In the file `run_tracker_performance_evaluation.m`, you can
* Change `evaluation_dataset_type` (line 26) for evaluation on all 1,400 sequences (i.e., **protocol I: no constrains**), 280 testing sequences (i.e., **protocol II: full-overlap**) or 150 extension sequences (i.e., **protocol III: one-shot**)
* For **protocol I**, the evaluation of 13 newly collected tracking algorithms are **NOT** available. Check the file `utils/config_tracker.m` 
* Change `norm_dst` (line 29) for precision or normalized precision plots

In the file `utils/plot_draw_save.m`
* change the plotting settings to get the appropriate plots

## Citation
If you use LaSOT and this evaluation toolkit for you researches, please consider citing our paper:
* <a href="https://arxiv.org/abs/2009.03465">LaSOT: A High-quality Large-scale Single Object Tracking Benchmark</a> <br>
H. Fan*, H. Bai*, L. Lin, F. Yang, P. Chu, G. Deng, S. Yu, Harshit, M. Huang, J Liu, Y. Xu, C. Liao, L Yuan, and H. Ling <br>
*arXiv:2009.03465*, 2020.
* <a href="https://arxiv.org/pdf/1809.07845.pdf">LaSOT: A High-quality Benchmark for Large-scale Single Object Tracking</a> <br> 
H. Fan*, L. Lin*, F. Yang*, P. Chu*, G. Deng, S. Yu, H. Bai, Y. Xu, C. Liao, and H. Ling <br> 
In *IEEE Conference on Computer Vision and Pattern Recognition (CVPR)*, 2019.

## Contact
If you have any questions on <a href="http://vision.cs.stonybrook.edu/~lasot/">LaSOT</a>, please feel free to contact Heng Fan at hefan@cs.stonybrook.edu.
