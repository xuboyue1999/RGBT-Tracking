


close all;
clear all;
clc;
algs={'rtmdnet_rgbt234_random1_fix2_994_5510_grad_clip100','MDNet+RGBT','MANet','ECO','ADNet','MEEM','SiamDW+RGBT','DAPNet','RT-MDNet','DAT','STRUCK','SGT','XT'}
%algs={'ours'};
pixelThreshold=5;

colorStyle(:,:,1)=[1,0,0];colorStyle(:,:,2)=[0,0,1];colorStyle(:,:,3)=[0,1,0];colorStyle(:,:,4)=[0,1,1];
colorStyle(:,:,5)=[1,0,1];colorStyle(:,:,6)=[1,1,0];colorStyle(:,:,7)=[0,0,0];colorStyle(:,:,8)=[0.5,0.5,0];
colorStyle(:,:,9)=[1,0.5,0.5];colorStyle(:,:,10)=[0.5,0,0.5];colorStyle(:,:,11)=[0,0.5,0.5];
colorStyle(:,:,12)=[1,0,0];colorStyle(:,:,13)=[0,0,1];colorStyle(:,:,14)=[0,1,0];colorStyle(:,:,15)=[0,1,1];
colorStyle(:,:,16)=[1,0,1];colorStyle(:,:,17)=[1,1,0];colorStyle(:,:,18)=[0,0,0];colorStyle(:,:,19)=[0.5,0.5,0];
colorStyle(:,:,20)=[1,0.5,0.5];colorStyle(:,:,21)=[0.5,0,0.5];colorStyle(:,:,22)=[0,0.5,0.5];

lineStyle = cell(1,22);
lineStyle(1:11) = {'-','-','-','-','-','-','-','-','-','-','-'};
lineStyle(12:22) = {'--','--','--','--','--','--','--','--','--','--','--'};

basePath='/home/fc/GTOT/';
sequences=dir(basePath);
sequences={sequences.name};
sequences=sequences(3:end);
precisionX=[0:0.5:25];
successX=[0:0.02:1];
% precisionY=zeros(size(precisionX));
precisionY=zeros([size(precisionX,2) size(algs,2)]);
% successY=zeros(size(successX));
successY=zeros([size(successX,2) size(algs,2)]);
allFramesNum=0;

for algIndex=1:size(algs,2),
for seqIndex=1:size(sequences,2),
%     ['results/' algs{1} '/' algs{1} '_' sequences{i} '.mat']
    if (strcmp('MCNet',algs{algIndex})),  
        results(seqIndex)=load(['ERRresults/ours' '/' 'ours' '_' sequences{seqIndex} '.mat']);
    else
        results(seqIndex)=load(['ERRresults/' algs{algIndex} '/' algs{algIndex} '_' sequences{seqIndex} '.mat']);
    end
    allFramesNum=allFramesNum+size(results(seqIndex).err,1);
    for j=1:size(successX,2),
    precisionY(j,algIndex)=precisionY(j,algIndex)+sum(results(seqIndex).errCenter<precisionX(j));
    successY(j,algIndex)=successY(j,algIndex)+sum(results(seqIndex).err>successX(j));
    end
    
    
end
end

allFramesNum=allFramesNum/size(algs,2);
%sort
 precisionthr(1:size(algs,2))=precisionY(2*pixelThreshold+1,1:size(algs,2))/allFramesNum;

    [~,precisionIndex]=sort(precisionthr,'descend');

h1=figure(1)
for trackerIndex=1:size(algs,2),
 if strcmp(algs{precisionIndex(trackerIndex)},'WJSR')
     algs{precisionIndex(trackerIndex)}='CSR';
 end
 %plot(precisionX,precisionY(:,precisionIndex(trackerIndex))'/allFramesNum,'color',colorStyle(:,:,precisionIndex(trackerIndex)),'LineWidth',3,'LineStyle',lineStyle(:,:,precisionIndex(trackerIndex)));
 plot(precisionX,precisionY(:,precisionIndex(trackerIndex))'/allFramesNum,'color',colorStyle(:,:,precisionIndex(trackerIndex)),'LineWidth',3,'LineStyle',lineStyle{precisionIndex(trackerIndex)});

 hold on  
 precision=num2str(precisionY(2*pixelThreshold+1,precisionIndex(trackerIndex))/allFramesNum,3);
 legendLabel{trackerIndex}=[algs{precisionIndex(trackerIndex)} '[' precision ']'];
end


title('Precision Plot'); 
% xlabel(h1,'string', 'Location error threshold','FontSize',20)
% ylabel(h1,'string','Precision','FontSize',20) 
xlabel( 'Location error threshold','FontSize',20)                           % matlab2015 �汾֮�󣬵���ʱ����ʹ�ø�ʽ����
ylabel( 'Precision','FontSize',20) 
legend(legendLabel);
saveas(1,'PR_TPR.fig');
saveas(1,'PR_TPR.jpeg');

% auc(successX,successY(:,1)'/allFramesNum)
% auc(successX,successY(:,2)'/allFramesNum)
%sort
for i=1:size(algs,2),
successthr(i)=auc(successX,successY(:,i)'/allFramesNum);
end

    [~,successIndex]=sort(successthr,'descend');

h2=figure(2)
for trackerIndex=1:size(algs,2),
%plot(successX,successY(:,successIndex(trackerIndex))'/allFramesNum,'color',colorStyle(:,:,successIndex(trackerIndex)),'LineWidth',3,'LineStyle',lineStyle(:,:,successIndex(trackerIndex)));
plot(successX,successY(:,successIndex(trackerIndex))'/allFramesNum,'color',colorStyle(:,:,successIndex(trackerIndex)),'LineWidth',3,'LineStyle',lineStyle{successIndex(trackerIndex)});
hold on
area=num2str(auc(successX,successY(:,successIndex(trackerIndex))'/allFramesNum),3);
legendLabel1{trackerIndex}=[algs{successIndex(trackerIndex)} '[' area ']'];
end
title('Success Plot');        
% xlabel(h2,'string', 'overlap threshold','FontSize',20)
% ylabel(h2,'string','Success Rate','FontSize',20) 
xlabel( 'overlap threshold','FontSize',20)
ylabel( 'Success Rate','FontSize',20) 
legend(legendLabel1);
saveas(2,'SR_TPR.fig');
saveas(2,'SR_TPR.jpeg');
