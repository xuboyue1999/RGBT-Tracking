%������tracker�Ľ����һ��ͼ��,�����ڵ�ǰĿ¼�µ�trackingResultsDisplay��
clc;
close all;
clear all;

%tracker={'WJSR'};%,'STRUCK','CN','CT','MIL','SCM'};%,'STC','CSK','SemiB' };
%tracker={'Ours','SGT','Struck','SCM','JSR','KCF','L1-PF'}

%tracker={'PaGLe','Struck','CN','JSR','KCF','SCM','L1-PF'};%,'STC','CSK','SemiB' };
%tracker={'Ours'}
tracker={'MIRNet','MTNet','CAT'}
basePath='E:\GTOT\';
dirs = dir(basePath);
sequences = {dirs.name};
sequences(strcmp('.', sequences) | strcmp('..', sequences) | ...
	strcmp('anno', sequences) | ~[dirs.isdir]) = [];

for ni=1:50
sequence=sequences{ni}
trackerResultsPath='BBresults/';
sequencePath='E:\GTOT\';;
saveBasePath='trackingResultsDisplay/';
if(isdir(saveBasePath)==0),
    mkdir(saveBasePath);
end



savingPath=[saveBasePath sequence '/'];
if(isdir(savingPath)==0),
    mkdir(savingPath);
    mkdir([savingPath 'v/']);
    mkdir([savingPath 'i/']);
    
end
savingPath


edgeColor={'r','g','b','y','k','m','c','g','b'};
lineStyle={'-','-','-','-','-','-','-','-',':',':'};
for trackerIndex=1:length(tracker),
    if (isempty(strfind(tracker{trackerIndex},'_v'))==1)&&(isempty(strfind(tracker{trackerIndex},'_i'))==1),
         trackerResult(:,:,trackerIndex)=dlmread([trackerResultsPath tracker{trackerIndex} '/'  tracker{trackerIndex} '_' sequence '.txt']);
         
    else
        if isempty(strfind(tracker{trackerIndex},'_v'))==1,%����ģ̬
            trackerName=tracker{trackerIndex}(1:strfind(tracker{trackerIndex},'_i')-1);
            
            trackerResult(:,:,trackerIndex)=dlmread([trackerResultsPath trackerName '_' sequence '_i.txt']);
        else
            
            trackerName=tracker{trackerIndex}(1:strfind(tracker{trackerIndex},'_v')-1);
            trackerName
            trackerResult(:,:,trackerIndex)=dlmread([trackerResultsPath trackerName '_' sequence '_v.txt']);%�ɼ��ģ̬
        end
       
    end
           
end

frames_v=dir([sequencePath sequence '/v/*.png']);
frames_i=dir([sequencePath sequence '/i/*.png']);
if(isempty(frames_v)==1),
    frames_v=dir([sequencePath sequence '/v/*.bmp']);
end

if(isempty(frames_i)==1),
    frames_i=dir([sequencePath sequence '/i/*.bmp']);
end

frames_v={frames_v.name};
frames_i={frames_i.name};
 bb=[trackerResult(:,1,:),  trackerResult(:,2,:) , trackerResult(:,5,:)-trackerResult(:,1,:),trackerResult(:,6,:)-trackerResult(:,2,:)]   ;

for frameIndex=1:length(frames_v),
    im=imread([sequencePath sequence '/v/' frames_v{frameIndex}]);
    imshow(uint8(im));
    for trackerIndex=1:length(tracker),
         if ~isempty(strfind(tracker{trackerIndex},'_i'))==1 %����Ǻ���ģ̬ ����Ҫ�ڿɼ��ģ̬�»����
            continue;
        end
       rectangle('Position',bb(frameIndex,:,trackerIndex),'LineWidth',2,'EdgeColor',edgeColor{trackerIndex},'LineStyle',lineStyle{trackerIndex});
    end
        hold on;
        text(5, 18, strcat('#',num2str(frameIndex)), 'Color','y', 'FontWeight','bold', 'FontSize',20);
        set(gca,'position',[0 0 1 1]); 
        pause(0.00001); 
        hold off;
        imwrite(frame2im(getframe(gcf)),[savingPath 'v/'  num2str(frameIndex) '.jpg']);
%       bb=[trackerResult(frameIndex,1,1),  trackerResult(frameIndex,2,1) , trackerResult(frameIndex,5,1)-trackerResult(frameIndex,1,1),trackerResult(frameIndex,6,1)-trackerResult(frameIndex,2,1)]
%      rectangle('Position', bb,'EdgeColor','r','LineWidth',5); 
%     hold off;
       
end



for frameIndex=1:length(frames_v),
    im=imread([sequencePath sequence '/i/' frames_i{frameIndex}]);
    imshow(uint8(im));
    for trackerIndex=1:length(tracker),
        if ~isempty(strfind(tracker{trackerIndex},'_v'))==1, %����ǿɼ��ģ̬tracker ����Ҫ�ں���ģ̬�»����
            continue;
        end
        
       rectangle('Position',bb(frameIndex,:,trackerIndex),'LineWidth',2,'EdgeColor',edgeColor{trackerIndex},'LineStyle',lineStyle{trackerIndex});
    end
        hold on;
        text(5, 18, strcat('#',num2str(frameIndex)), 'Color','y', 'FontWeight','bold', 'FontSize',20);
        set(gca,'position',[0 0 1 1]); 
        pause(0.00001); 
        hold off;
        imwrite(frame2im(getframe(gcf)),[savingPath 'i/'  num2str(frameIndex) '.jpg']);
%       bb=[trackerResult(frameIndex,1,1),  trackerResult(frameIndex,2,1) , trackerResult(frameIndex,5,1)-trackerResult(frameIndex,1,1),trackerResult(frameIndex,6,1)-trackerResult(frameIndex,2,1)]
%      rectangle('Position', bb,'EdgeColor','r','LineWidth',5); 
%     hold off;
       
end
clear trackerResult;
end