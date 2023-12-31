function trackers = config_tracker()
% config trackers to be evaluated
% note: the evaluation under protocol 1 (i.e., all 1,400 videos) for newly
% added 13 trackers are not available. Thus, you may need to comment these
% 13 trackers (ATOM, DiMP, C-RPN, SiamRPN++, DaSiamRPN, D-STRCF, SiamDW, GFSDCF, 
% SiamMask, GlobalTrack, SPLT, ASRCF, LTMU) when performing evaluation using 
% all 1,400 videos.
% trackers = {struct('name', 'ATOM',       'publish', 'CVPR2019') ...
%             struct('name', 'CLNet',      'publish', 'ECCV2020') ...
%             struct('name', 'D3S',         'publish', 'ECCV2020') ...
%             struct('name', 'DaSiamRPN',        'publish', 'ECCV-12') ...
%             struct('name', 'DiMP50',     'publish', 'CVPR2019') ...
%             struct('name', 'ECO',       'publish', 'CVPR2015') ...
%             struct('name', 'GlobalTrack',         'publish', 'ECCV-12') ...
%             struct('name', 'KYS',      'publish', 'ICCV-17') ...
%             struct('name', 'LTMU',       'publish', 'CVPR2020') ...
%             struct('name', 'MDNet',     'publish', 'CVPR-17') ...
%             struct('name', 'Meta-Tracker',        'publish', 'CVPR-17') ...
%             struct('name', 'Ocean',       'publish', 'ICCV-15') ...
%             struct('name', 'PrDiMP50',      'publish', 'TPAMI-17')...
%             struct('name', 'RT-MDNet',       'publish', 'ICCV-17')...
%             struct('name', 'SiamBAN',        'publish', 'IJCV-08') ...
%             struct('name', 'SiamCAR',        'publish', 'TPAMI-15')...
%             struct('name', 'SiamFC++',      'publish', 'CVPR-12') ...
%             struct('name', 'SiamMask',        'publish', 'CVPR-15') ...
%             struct('name', 'SiamR-CNN',       'publish', 'ECCV-14') ...
%             struct('name', 'SiamRPN',        'publish', 'CVPR-09') ...
%             struct('name', 'SiamRPN++',       'publish', 'ECCVW-14')...
%             struct('name', 'Super-DiMP',       'publish', 'CVPR-16') ...
%             struct('name', 'VITAL',     'publish', 'ECCVW-16')...
%             };
% trackers = {struct('name', 'RT', 'publish', '1111'),...
%            struct('name', 'TAM', 'publish', '1111')...
%            };
trackers = {
    struct('name', 'CAT', 'publish', '1111')...
    struct('name', 'CMR', 'publish', '1111')...
    struct('name', 'DAFNet', 'publish', '1111')...
    struct('name', 'DAPNet', 'publish', '1111')...
    struct('name', 'DMCNet', 'publish', '1111')...
    struct('name', 'FANet', 'publish', '1111')...
    struct('name', 'MaCNet', 'publish', '1111')...
    struct('name', 'MANet', 'publish', '1111')...
    struct('name', 'mfDiMP', 'publish', '1111')...
    struct('name', 'MANet++', 'publish', '1111')...
    struct('name', 'SGT', 'publish', '1111')...
    struct('name', 'SGT++', 'publish', '1111')...
    struct('name', 'my', 'publish', '1111')...
    %struct('name', 'siamfcpp_AlexNet_cat2conv_test_lasher_epoch-29', 'publish', '1111')...
             };

end