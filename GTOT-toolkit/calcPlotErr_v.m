%这个函数计算中心错误和重合比，结果保存在results/TrackerName_seqName.mat下  
%单模态下的

function [aveErrCoverageAll aveErrCenterAll] = calcPlotErr_v(seqs, trks,  bPlot)
basePath='..\dataset\';
resultPath='BBresults\';
LineWidth = 2;
LineStyle = '-';%':';%':' '.-'
% Curvature = [0,0];

% path_anno = '.\anno\';
lostCount = zeros(length(seqs), length(trks));
thred = 0.33;
% lostRate = zeros(length(seqs), length(trks));
% lostRateEachAlg = zeros(1, length(trks));
errCenterAll=[];
errCoverageAll=[];

lenTotalSeq = 0;
precisonPlot=0;
successPlot=0;
rectMat=[];
modal='v';
for index_seq=1:length(seqs)
    seq = seqs{index_seq};
%     seq_name = seq.name
    seq_name=seq;
    fileName = [basePath seq_name  '/groundTruth_'   modal '.txt'];%groundTruth
%     fileName
    rect_anno = dlmread(fileName);
%     seq_length = seq.endFrame-seq.startFrame+1; %size(rect_anno,1);
%     lenTotalSeq = lenTotalSeq + seq_length;
    seq_length=size(rect_anno,1);
    lenTotalSeq = lenTotalSeq + seq_length;
    centerGT = [(rect_anno(:,1)+rect_anno(:,3))/2 (rect_anno(:,2)+rect_anno(:,4))/2];%groundTruth's center
    rect_wh=[rect_anno(:,1),rect_anno(:,2),rect_anno(:,3)-rect_anno(:,1),rect_anno(:,4)-rect_anno(:,2)];% x y w h
    %     rect=[];
%     indexLost = zeros(length(trks), seq_length);
%     if bPlot
%         clf
%     end
    
    for index_algrm=1:length(trks)
        algrm = trks{index_algrm};
%         name=algrm.name;
        name=algrm;
        trackerNames{index_algrm}=name;
        
%         res_path = [pathRes seq_name '_' name '/'];
        
%         fileName = [pathRes seq_name '_' name '.mat'];%读取该算法的结果
        
%         load(fileName);
%         [basePath seq_name '\' name '_result.txt']
%         results.res=dlmread([basePath seq_name '\' modal '\' name '_result_' modal '.txt']); %seq_length*8
          results.res=dlmread([resultPath,name,'_',seq_name,'_v.txt']);%Or _i.txt
        results.type='4corner';
        rectMat = zeros(seq_length, 4);
        
        switch results.type
            case 'rect'                
                rectMat = results.res;
            case 'ivtAff'
                for i = 1:seq_length
                    [rect c] = calcRectCenter(results.tmplsize, results.res(i,:), 'Color', [1 1 1], 'LineWidth', LineWidth,'LineStyle',LineStyle);
                    rectMat(i,:) = rect;
                    %                     center(i,:) = c;
                end
            case 'L1Aff'
                for i = 1:seq_length
                    [rect c] = calcCenter_L1(results.res(i,:), results.tmplsize);
                    rectMat(i,:) = rect;
                end
            case 'LK_Aff'
                for i = 1:seq_length
                    [corner c] = getLKcorner(results.res(2*i-1:2*i,:), results.tmplsize);
                    rectMat(i,:) = corner2rect(corner);
                end
            case '4corner'
                for i = 1:seq_length
%                      rectMat(i,:) = corner2rect(results.res(2*i-1:2*i,:));
                rectMat(i,:) = corner2rect(results.res(i,:));
                end
            otherwise
                continue;
        end 
 
        center = [rectMat(:,1)+(rectMat(:,3))/2 rectMat(:,2)+(rectMat(:,4))/2];
%         rectMat(1,3)
%         center(1,:)
%         centerGT(1,:)
%         size(center)
        
%         center(1:seq_length,:)
%         size((centerGT(1:seq_length,:)))
        err = calcRectInt(rectMat(1:seq_length,:),rect_wh(1:seq_length,:));
%         rectMat(1,:)
%         rect_anno(1,:)
%         err(1,1)
        errCenter = sqrt(sum(((center(1:seq_length,:) - centerGT(1:seq_length,:)).^2),2));
%         errCenter(100,1)
        if(isdir(['ERRresults/' name '_' modal])==0),
            mkdir(['ERRresults/' name '_' modal]);
        end
        save([['ERRresults/' name '_' modal] '/' name '_' modal '_' seq_name '.mat'], 'err','errCenter');
        
        if bPlot            
            h1=figure(1);
%             plot(err(:,index_algrm),'color', trks{index_algrm}.color,'LineWidth',LineWidth,'LineStyle',LineStyle);
            plot(err,'color',[0,1,0],'LineWidth',LineWidth,'LineStyle',LineStyle);
            hold on 
            
            h2=figure(2);
            plot(errCenter,'color', [0,1,0],'LineWidth',LineWidth,'LineStyle',LineStyle);
            hold on
            
        end
    end
    
    if bPlot
        figure(1);
        axis tight
        set(gca,'fontsize',20);
        
        xlabel(h1,'string', ['# ' seqs{index_seq}],'FontSize',20)
        ylabel(h1,'string','Coverage/quality','FontSize',20)        
%         legend(trackerNames,'Orientation','horizontal','Position', [0.20 0.004 0.59 0.05]);
%         legend(trackerNames,'Position', 'Best');
        
%         print(h1, '-depsc', [pathPlot seq_name '_coverage']);
%         imwrite(frame2im(getframe(h1)), [pathPlot seq_name '_coverage.png']);
               
        figure(2);
        axis tight;
        set(gca,'fontsize',20);

        xlabel(h2,'string',['# ' seqs{index_seq}],'FontSize',20)
        ylabel(h2,'string','Center error','FontSize',20)
%         legend(trackerNames,'Position', 'Best');
        
%         print(h2, '-depsc', [pathPlot seq_name '_center']);
%         imwrite(frame2im(getframe(h2)), [pathPlot seq_name '_center.png']);
        
        clf(h1);
        clf(h2);
    end
    
    aveErrCoverage(index_seq,:) = sum(err)/seq_length;
    errCoverageAll(index_seq,:) = sum(err);
    
    aveErrCenter(index_seq,:) = sum(errCenter)/seq_length;
    errCenterAll(index_seq,:) = sum(errCenter);
    
    lostCount(index_seq,:)=sum(err<thred);
     precisonPlot=precisonPlot+sum(errCenter<=20);
     successPlot=successPlot+sum(err>0.5);
    err = [];
    errCenter=[];
end
% lenTotalSeq
% aveErrCoverageAll=sum(errCoverageAll)/lenTotalSeq    %所有的相交比

% aveErrCenterAll=sum(errCenterAll)/lenTotalSeq        %所有的中心错误
% precisonPlot
% precisonPlot/lenTotalSeq
% successPlot/lenTotalSeq
% save(['./errAnalysis.mat'], 'aveErrCoverage', 'aveErrCenter', 'aveErrCoverageAll', 'aveErrCenterAll', 'lostCount', 'thred');
% lostRateEachAlg=sum(lostCount)/lenTotalSeq
% lostCount
% sum(lostCount)