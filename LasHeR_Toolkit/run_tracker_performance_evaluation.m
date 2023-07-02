% tracker performance evaluation tool for our benchmark
% 07/19/2018
%配annos的，是自己的真值
%sequence_evaluation_config 配的是跟踪序列
%tracking_results里加上自己的跟踪结果，跟踪器+tracking_results来存放跟踪结果
%configtrackers里修改自己的跟踪器
clc; clear; close all;

addpath('./utils/');
addpath('./sequence_evaluation_config/');

tmp_mat_path  = './tmp_mat/';          % path to save temporary results
path_anno     = './annos/';            % path to annotations
path_att      = './annos/att/';        % path to attribute
rp_all        = './tracking_results/'; % path to tracking results
save_fig_path = './res_fig/';          % path to result figures
save_fig_suf  = 'eps';                 % suffix of figures, 'png' or 'eps'

att_name = {'Scale Variation','Fast Motion','Object Disappear','Illumination Variation',...
    'Camera Motion','Motion Blur','Blackground Clutter','Similar Object','Deformation','Partial Occlusion','Full Occlusion',...
    'Abrupt Motion','Tiny Object','Low Illumination'};
att_fig_name  = {'SV', 'FM', 'OD', 'IV', 'CM', 'MB', 'BC', ...
                 'SO', 'DEF', 'PO', 'FO', 'AM', 'TO', 'LI'};

% 'all' --- evaluation with the whole benchmark
% 'test_set' --- evaluation with training subset
% 'extension_test_set' --- 
% evaluation on the extension set
evaluation_dataset_type = 'lashertest';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use normalization or not  这个是控制PR和NPR
% change it or not for NPR
norm_dst = false; 
%norm_dst =true; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

trackers   = config_tracker();
sequences  = config_sequence(evaluation_dataset_type);
plot_style = config_plot_style();

num_seq = numel(sequences);
num_tracker = numel(trackers);

% load tracker info
name_tracker_all = cell(num_tracker, 1);
for i = 1:num_tracker
    name_tracker_all{i} = trackers{i}.name;
end

% load sequence info
name_seq_all = cell(num_seq, 1);
% for i = 1:num_seq
%     name_seq_all{i} = sequences{i};
%     seq_att = dlmread(fullfile(path_att, [sequences{i} '.txt']));
%     if i == 1
%         att_all = zeros(num_seq, numel(seq_att));
%     end
%     att_all(i, :) = seq_att;
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parameters for evaluation
%threshold使用的是可以画PR和SR（SR是不准确的）曲线，AUC画的是AUC曲线
metric_type_set = {'error', 'overlap'};
eval_type       = 'OPE';
ranking_type    = 'AUC';                                                  
%ranking_type    = 'threshold';   % change it to 'AUC' for success plots  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rank_num        = 48;

threshold_set_error   = 0:50;
if norm_dst
    threshold_set_error = threshold_set_error / 100;
end
threshold_set_overlap = 0:0.05:1;

for i = 1:numel(metric_type_set)
    % error (for distance plots) or overlap (for success plots)
    metric_type = metric_type_set{i};
    switch metric_type
        case 'error'
            threshold_set = threshold_set_error;
            rank_idx      = 21;
            x_label_name  = 'Location error threshold';
            y_label_name  = 'Precision rate';
        case 'overlap'
            threshold_set = threshold_set_overlap;
            rank_idx      = 11;
            x_label_name  = 'Overlap threshold';
            y_label_name  = 'Success rate';
    end
    
    if strcmp(metric_type, 'error') && strcmp(ranking_type, 'AUC') % for ranking_type = 'AUC'
%     if strcmp(metric_type, 'overlap') && strcmp(ranking_type, 'threshold')  % for ranking_type = 'threshold'
        continue;
    end
   
    t_num = numel(threshold_set);
    
    % we only use OPE for evaluation
    plot_type = [metric_type '_' eval_type];
    
    switch metric_type
        case 'error'
            title_name = ['Precision plots of ' eval_type];
            if norm_dst
                title_name = ['Normalized ' title_name];
%                 title_name = ['Normalized ' title_name];
            end
            
            if strcmp(evaluation_dataset_type, 'all')
                title_name = [title_name ' on SOT'];
            else
                title_name = [title_name ' on SOT Testing Set'];
            end
        case 'overlap'
            title_name = ['Success plots of ' eval_type];
            
            if strcmp(evaluation_dataset_type, 'all')
                title_name = [title_name ' on SOT'];
            else
                title_name = [title_name ' on SOT Testing Set'];
            end
    end
    
    dataName = [tmp_mat_path 'aveSuccessRatePlot_' num2str(num_tracker) ...
                'alg_'  plot_type '.mat'];
    
    % evaluate tracker performance
    if ~exist(dataName, 'file') || true
        eval_tracker(sequences, trackers, eval_type, name_tracker_all, ...
                    tmp_mat_path, path_anno, rp_all, norm_dst);
    end
    
    % plot performance
    load(dataName);
    num_tracker = size(ave_success_rate_plot, 1);
    
    if rank_num > num_tracker || rank_num <0
        rank_num = num_tracker;
    end
    
    fig_name= [plot_type '_' ranking_type];
    idx_seq_set = 1:numel(sequences);
    
    % draw and save the overall performance plot
    plot_draw_save(num_tracker, plot_style, ave_success_rate_plot, ...
                   idx_seq_set, rank_num, ranking_type, rank_idx, ...
                   name_tracker_all, threshold_set, title_name, ...
                   x_label_name, y_label_name, fig_name, save_fig_path, ...
                   save_fig_suf);
               
    % draw and save the per-attribute performance plot
%     att_trld = 0;
%     att_num  = size(att_all, 2);
%     for att_idx = 1:att_num    % for each attribute
%         idx_seq_set = find(att_all(:, att_idx) > att_trld);
%         if length(idx_seq_set) < 2
%             continue;
%         end
%         disp([att_name{att_idx} ' ' num2str(length(idx_seq_set))]);
%         
%         fig_name   = [att_fig_name{att_idx} '_'  plot_type '_' ranking_type];
%         title_name = ['Plots of ' eval_type ': ' att_name{att_idx} ' (' num2str(length(idx_seq_set)) ')'];
%         
%         switch metric_type
%             case 'overlap'
%                 title_name = ['Success plots of ' eval_type ' - ' att_name{att_idx} ' (' num2str(length(idx_seq_set)) ')'];
%             case 'error'
%                 title_name = ['Precision plots of ' eval_type ' - ' att_name{att_idx} ' (' num2str(length(idx_seq_set)) ')'];
%                 if norm_dst
% %                     title_name = ['Normalized ' title_name];
%                     title_name = ['N ' title_name];
%                 end
%         end
%         
%         plot_draw_save(num_tracker, plot_style, ave_success_rate_plot, ...
%                    idx_seq_set, rank_num, ranking_type, rank_idx, ...
%                    name_tracker_all, threshold_set, title_name, ...
%                    x_label_name, y_label_name, fig_name, save_fig_path, ...
%                    save_fig_suf);
%     end
end