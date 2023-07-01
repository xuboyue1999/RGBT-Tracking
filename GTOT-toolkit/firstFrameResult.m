%所有sequences的第一帧结果 保存在
clear all;
close all;
clc;
basePath='D:\MultimodalDataset\dataset\dataset\';
resultPath='E:\PlotErr\theResultOfFirstFrame/';
sequences=dir(basePath);
sequences={sequences.name};
sequences=sequences(3:end);
% sequences{31}
for seqIndex=31:size(sequences,2),
    close all;
    GT1=dlmread([basePath sequences{seqIndex} '/v/groundTruth.txt']);
    bb1=[GT1(1,1),GT1(1,2),GT1(1,3)-GT1(1,1),GT1(1,4)-GT1(1,2)];
    
    GT2=dlmread([basePath sequences{seqIndex} '/i/groundTruth.txt']);
    bb2=[GT2(1,1),GT2(1,2),GT2(1,3)-GT2(1,1),GT2(1,4)-GT2(1,2)];
    
    allframes1=dir([basePath sequences{seqIndex} '/v/*.png']);
    if(size(allframes1,1)==0),
        allframes1=dir([basePath sequences{seqIndex} '/v/*.bmp']);
    end
    allframes1={allframes1.name};
    firstFrame1=imread([basePath sequences{seqIndex} '/v/' allframes1{1}]);
    
    allframes2=dir([basePath sequences{seqIndex} '/i/*.png']);
    if(size(allframes2,1)==0),
        allframes2=dir([basePath sequences{seqIndex} '/i/*.bmp']);
    end
    allframes2={allframes2.name};
    firstFrame2=imread([basePath sequences{seqIndex} '/i/' allframes2{1}]);
    
    axes('position',[.0  .0  1.0  1.0]);
    imshow(firstFrame1) , hold on;  
    rectangle('Position', bb1,'EdgeColor','r','LineWidth',5);    
    saveas(gcf,[resultPath sequences{seqIndex} '_v.png']);
    t1=imread([resultPath sequences{seqIndex} '_v.png']);
    t1=imresize(t1,[240 300]);
    
    imwrite(t1, [resultPath sequences{seqIndex} '_v.png']);
    
    
    
    axes('position',[.0  .0  1.0  1.0]);
    imshow(firstFrame2) , hold on;  
    rectangle('Position', bb2,'EdgeColor','r','LineWidth',5);    
    saveas(gcf,[resultPath sequences{seqIndex} '_i.png']);
    t1=imread([resultPath sequences{seqIndex} '_i.png']);
    t1=imresize(t1,[240 300]);
    
    imwrite(t1, [resultPath sequences{seqIndex} '_i.png']);
    
end