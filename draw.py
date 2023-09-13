import os

import matplotlib.pyplot as plt
import numpy as np

# 从文件中读取bbox数据
def read_bbox_file(file_path, is_corner_format=False, delimiter=','):
    bboxes = []
    with open(file_path, 'r') as file:
        for line in file:
            if is_corner_format:
                corners = list(map(float, line.strip().split(delimiter)))
                x = (corners[0] + corners[4]) // 2
                y = (corners[1] + corners[3]) // 2
                w = corners[2] - corners[0]
                h = corners[3] - corners[1]
                bboxes.append((x, y, w, h))
            else:
                x, y, w, h = map(float, line.strip().split(delimiter))
                bboxes.append((x, y, w, h))
    return bboxes

# 判断bbox数据的格式
def detect_bbox_format(file_path):
    with open(file_path, 'r') as file:
        line = file.readline().strip()
        # print(line.split())
        num_values = len(line.split(','))
        # print(num_values)
        if num_values == 4:
            delimiter = ',' if ',' in line else ' '  # 判断分隔符
            return False, delimiter  # 使用 (x, y, w, h) 格式
        elif num_values == 8:
            delimiter = ',' if ',' in line else ' '  # 判断分隔符
            return True, delimiter  # 使用 (x1, y1, x2, y2, x3, y3, x4, y4) 格式
        else:
            raise ValueError("Unsupported bbox format")

def get_seqs(path):
    seqs = []
    for i in os.listdir(path):
        if i.endswith('.txt') and i.split('_')[-1]!='time.txt':
            seqs.append(i)
    return seqs

# 读取bbox数据并判断格式
seqs=get_seqs('result1')
for seq in seqs:
    print(seq)
    gt_bbox_path = 'gt/'+seq
    predicted_bbox_path2 = 'result1/'+seq
    predicted_bbox_path = 'result2/'+seq
    is_corner_format, delimiter = detect_bbox_format(gt_bbox_path)
    if is_corner_format:
        gt_bboxes = read_bbox_file(gt_bbox_path, is_corner_format=True, delimiter=',')
        predicted_bboxes = read_bbox_file(predicted_bbox_path, is_corner_format=True, delimiter='\t')
        predicted_bboxes2 = read_bbox_file(predicted_bbox_path2, is_corner_format=True, delimiter='\t')
    else:
        gt_bboxes = read_bbox_file(gt_bbox_path, delimiter=delimiter)
        predicted_bboxes = read_bbox_file(predicted_bbox_path, delimiter='\t')
        predicted_bboxes2 = read_bbox_file(predicted_bbox_path2, is_corner_format=False, delimiter='\t')

    # 计算CLE值并保存
    cle_values = []
    cle_values2 = []
    for gt_bbox, pred_bbox,pred_bbox2 in zip(gt_bboxes, predicted_bboxes,predicted_bboxes2):
        gt_center = np.array([gt_bbox[0] + gt_bbox[2] // 2, gt_bbox[1] + gt_bbox[3] // 2])
        pred_center = np.array([pred_bbox[0] + pred_bbox[2] // 2, pred_bbox[1] + pred_bbox[3] // 2])
        pred_center2 = np.array([pred_bbox2[0] + pred_bbox2[2] // 2, pred_bbox2[1] + pred_bbox2[3] // 2])
        cle = np.linalg.norm(gt_center - pred_center)  # 计算欧式距离作为CLE值
        cle_values.append(cle)
        cle2 = np.linalg.norm(gt_center - pred_center2)  # 计算欧式距离作为CLE值
        cle_values2.append(cle2)



    # 创建绘图
    frames = list(range(1, len(gt_bboxes) + 1))  # 假设每个bbox对应一个帧

    # 设置横坐标轴标签密度
    max_labels = 100  # 你可以根据需要调整横坐标轴标签的密度
    step = max(1, len(frames) // max_labels)

    # 调整图表的大小，拉大横坐标之间的间距
    plt.figure(figsize=(20, 6))  # 调整 figsize 参数来控制图表的大小

    # 仅在有标签的点上绘制数据
    plt.plot(frames[::step], cle_values[::step], linestyle='-', color='red', markersize=5, markerfacecolor=(68/255, 114/255, 196/255), linewidth=3)  # 绘制有标签的数据点
    plt.plot(frames[::step], cle_values2[::step], linestyle='-', color=(255/255, 165/255, 0/255), markersize=5, markerfacecolor=(68/255, 114/255, 196/255), linewidth=3)  # 绘制有标签的数据点
    plt.axhline(y=40, color='green', linestyle='--')  # 在纵坐标 40 的位置画红色虚线
    plt.xlabel('Frames')
    plt.ylabel('CLE')

    # 设置竖向的横坐标文字，并根据密度采样
    plt.xticks(frames[::step], labels=frames[::step], rotation='vertical')

    plt.xlim(1, len(gt_bboxes))  # 设置横坐标范围从1开始
    plt.ylim(0)  # 设置纵坐标从0开始
    plt.grid(False)  # 去掉网格线
    plt.savefig('res/'+seq.split('.')[0]+'.png', bbox_inches='tight')
    plt.show()
    # break

