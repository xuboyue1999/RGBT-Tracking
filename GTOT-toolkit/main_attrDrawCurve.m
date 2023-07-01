%�������OCC	LSV	FM	LI	HI	TC	LR	DEF ����Ӧ��precision��success����
close all;
clear all;
clc;
pixelThreshold=5;

attrMat='./sequencesAttr/AttrMat.mat';%���Ա����mat

basePath='E:\GTOT\';
resultMatPath='ERRresults/';
attrDisplay='ALL';%��ĳ�����Ե�����  OCC LSV	FM	LI		TC	SO	DEF All
% algs={'SCM','SCM_i','SCM_v','STRUCK','STRUCK_i','STRUCK_v','CN','STC','CSK','CT','CN_i',...
%     'CN_v','STC_v','STC_i','CSK_v','CSK_i','CT_v','CT_i'...
% %     };
algs={'APFNet','DMCNet','HMFT','JMMAC','MacNet','MANet++','MIRNet','MTNet','ADRNet','SiamCDA','CAT','CMPP'};
%algs={''}
%algs={'MACoR','SCM','STRUCK','CSK','STC','CN','CT','MIL','TLD'};
%   algs={'SCM_i','STRUCK_i','CSK_i','STC_i','CN_i','CT_i','MUSter_i','MEEM_i','PCOM_i','MIL_i','TLD_i','RPT_i'};
%   algs={'SCM_v','STRUCK_v','CSK_v','STC_v','CN_v','CT_v','MUSter_v','MEEM_v','PCOM_v','MIL_v','TLD_v','RPT_v'};


attrs=load(attrMat);
colorStyle(:,:,1)=[1,0,0];colorStyle(:,:,2)=[0,0,1];colorStyle(:,:,3)=[0,1,0];colorStyle(:,:,4)=[0,1,1];colorStyle(:,:,5)=[1,0,1];
colorStyle(:,:,6)=[1,0,0];colorStyle(:,:,7)=[0,0,1];colorStyle(:,:,8)=[0,1,0];colorStyle(:,:,9)=[0,1,1];colorStyle(:,:,10)=[1,0,1];
colorStyle(:,:,11)=[1,0.5,0];colorStyle(:,:,12)=[0,0.5,1];colorStyle(:,:,13)=[0,1,0.5];colorStyle(:,:,14)=[0.5,1,1];colorStyle(:,:,15)=[1,0.5,1];
colorStyle(:,:,16)=[0.5,0,0];colorStyle(:,:,17)=[0,0,0.5];colorStyle(:,:,18)=[0,0.5,0];colorStyle(:,:,19)=[0,0.5,0.5];colorStyle(:,:,20)=[0.5,0,0.5];
lineStyle(:,:,1:8)='-';
lineStyle(:,:,9:16)=':';
sequencesAll=dir(basePath);
sequencesAll={sequencesAll.name};
sequencesAll=sequencesAll(3:end);

%�õ���Щ����AttrName������
sequences={};
if strcmp(attrDisplay,'ALL')==1,
    sequences=sequencesAll;
else

    jjj=0;
for seqIndex=1:length(sequencesAll),
     
     idx=find(strcmp(attrs.seqName, sequencesAll{seqIndex})==1);%�ҵ����������mat�е��±�
     switch attrDisplay,
         case 'OCC';
             if attrs.OCC(idx)==1,
                 sequences{end+1}=sequencesAll{seqIndex};
             end
             
         case 'LSV';
             if attrs.LSV(idx)==1,
                 sequences{end+1}=sequencesAll{seqIndex};
             end
         case 'FM';
             if attrs.FM(idx)==1,
                 sequences{end+1}=sequencesAll{seqIndex};
             end
         case 'LI';
             if attrs.LI(idx)==1,
                 sequences{end+1}=sequencesAll{seqIndex};
             end
         case 'HI';
             if attrs.HI(idx)==1,
                 sequences{end+1}=sequencesAll{seqIndex};
             end
         case 'TC';
             if attrs.TC(idx)==1,
                 sequences{end+1}=sequencesAll{seqIndex};
             end
         case 'SO';
             if attrs.SO(idx)==1,
                 sequences{end+1}=sequencesAll{seqIndex};
             end
         case 'DEF';
             if attrs.DEF(idx)==1,
                 sequences{end+1}=sequencesAll{seqIndex};
             end
       
         
     end
     
   
    
end
end

sequences
disp([attrDisplay 'seqNum:'  int2str(length(sequences))]);





precisionX=[0:0.5:25];
successX=[0:0.02:1];
% precisionY=zeros(size(precisionX));
precisionY=zeros([size(precisionX,2) size(algs,2)]);
% successY=zeros(size(successX));
successY=zeros([size(successX,2) size(algs,2)]);
allFramesNum=0;

for algIndex=1:size(algs,2),
for seqIndex=1:size(sequences,2),
%     ['results/' algs{1} '/' algs{1} '_' sequencesAll{i} '.mat']
    results(seqIndex)=load([resultMatPath algs{algIndex} '/' algs{algIndex} '_' sequences{seqIndex} '.mat']);
    allFramesNum=allFramesNum+size(results(seqIndex).err,1);
    for j=1:size(successX,2),
    precisionY(j,algIndex)=precisionY(j,algIndex)+sum(results(seqIndex).errCenter<precisionX(j));
    successY(j,algIndex)=successY(j,algIndex)+sum(results(seqIndex).err>successX(j));
    end
    
    
end
end


disp([attrDisplay 'FrameNum:' int2str(allFramesNum/length(algs))]);
allFramesNum=allFramesNum/size(algs,2);
%sort


%.................................................................................
%precision Plot
%.................................................................................
 precisionthr(1:size(algs,2))=precisionY(2*pixelThreshold+1,1:size(algs,2))/allFramesNum;

 [~,precisionIndex]=sort(precisionthr,'descend');

h1=figure('Name',attrDisplay)
for trackerIndex=1:size(algs,2),
    
 plot(precisionX,precisionY(:,precisionIndex(trackerIndex))'/allFramesNum,'color',colorStyle(:,:,trackerIndex),'LineWidth',3,'LineStyle',lineStyle(:,:,trackerIndex));
 hold on  
 precision=num2str(precisionY(2*pixelThreshold+1,precisionIndex(trackerIndex))/allFramesNum,3);
 legendLabel{trackerIndex}=[algs{precisionIndex(trackerIndex)} '[' precision ']'];
end


title('Precision Plot'); 
% xlabel(h1,'string', 'Location error threshold','FontSize',20)
% ylabel(h1,'string','Precision','FontSize',20) 
% legend(legendLabel);

xlabel('Location error threshold','FontSize',20)
ylabel('Maximum Precision Rate','FontSize',20)
legend(legendLabel,'Location','northwest');  %southeast

%.................................................................................
%success Plot
%.................................................................................
for i=1:size(algs,2),
successthr(i)=auc(successX,successY(:,i)'/allFramesNum);
end

[~,successIndex]=sort(successthr,'descend');
h2=figure('Name',attrDisplay)
for trackerIndex=1:size(algs,2),
plot(successX,successY(:,successIndex(trackerIndex))'/allFramesNum,'color',colorStyle(:,:,trackerIndex),'LineWidth',3,'LineStyle',lineStyle(:,:,trackerIndex));
hold on
area=num2str(auc(successX,successY(:,successIndex(trackerIndex))'/allFramesNum),3);
legendLabel1{trackerIndex}=[algs{successIndex(trackerIndex)} '[' area ']'];
end
title('Success Plot');        
xlabel('Overlap Threshold','FontSize',20)
ylabel('Maximum Success Rate','FontSize',20)
legend(legendLabel1);

