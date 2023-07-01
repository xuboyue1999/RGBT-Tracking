%��������ٽ����㷨����calcPlotErr
%����ǵõ�distance ���غϱȣ�������../results��../WJSRresults��
clear all;
close all;
clc;
basePath='E:\GTOT\';

sequences=dir(basePath);
sequences={sequences.name};
sequences=sequences(3:end);
%trackers={'SGT','MDNet+RGBT','CN','KCF','CSK','ours','SCM','Struck'};
%trackers={'APFNet','HMFT','JMMAC','MacNet','MANet++','MIR','ADRNet','MTNet'};
trackers={'HMFT'}

bPlot=1;
calcPlotErr(sequences, trackers,  bPlot);
