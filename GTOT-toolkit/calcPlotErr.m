%������������޸�groundTruth(v��i��ƽ��),��������ַ��Ҫ�޸ģ�
%���������ںϵ�
%��������������Ĵ�����غϱȣ����������results/TrackerName_seqName.mat�� 
function [aveErrCoverageAll aveErrCenterAll] = calcPlotErr(seqs, trks,  bPlot)
basePath='E:\GTOT\';
resultPath='BBresults/';
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

lenTotalSeqV = 0;
lenTotalSeqI = 0;
precisonPlot=0;
successPlot=0;
rectMat=[];
for index_seq=1:length(seqs)
    seq = seqs{index_seq}
%     seq_name = seq.name
    seq_name=seq;
    fileNameV = [basePath seq_name '/groundTruth_v.txt'];%groundTruth
    fileNameI = [basePath seq_name '/groundTruth_i.txt'];
%     fileName
    rect_annoV = dlmread(fileNameV);
    rect_annoI = dlmread(fileNameI);
%     seq_length = seq.endFrame-seq.startFrame+1; %size(rect_anno,1);
%     lenTotalSeq = lenTotalSeq + seq_length;
    seq_lengthV=size(rect_annoV,1);
    seq_lengthI=size(rect_annoI,1);
    lenTotalSeqV = lenTotalSeqV + seq_lengthV;
    lenTotalSeqI = lenTotalSeqI + seq_lengthI;
    centerGTV = [(rect_annoV(:,1)+rect_annoV(:,3))/2 (rect_annoV(:,2)+rect_annoV(:,4))/2];%groundTruth's center
    centerGTI = [(rect_annoI(:,1)+rect_annoI(:,3))/2 (rect_annoI(:,2)+rect_annoI(:,4))/2];
    rect_whV=[rect_annoV(:,1),rect_annoV(:,2),rect_annoV(:,3)-rect_annoV(:,1),rect_annoV(:,4)-rect_annoV(:,2)];% x y w h
    rect_whI=[rect_annoI(:,1),rect_annoI(:,2),rect_annoI(:,3)-rect_annoI(:,1),rect_annoI(:,4)-rect_annoI(:,2)];
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
        
%         fileName = [pathRes seq_name '_' name '.mat'];%��ȡ���㷨�Ľ��
        
%         load(fileName);
%         [basePath seq_name '\' name '_result.txt']
%         results.res=dlmread([basePath seq_name '/' name '_result.txt']); %seq_length*8
        
        results.res=dlmread([resultPath name '/' name '_' seq_name  '.txt']);
        
%         results.res=dlmread([resultPath 'rtmdnet_rgbt234_random1_fix2_994_5510_grad_clip100_' seq_name  '.txt']); %seq_length*8
        results.type='4corner';
        rectMat = zeros(seq_lengthV, 4);
        
        switch results.type
            case 'rect'                
                rectMat = results.res;
            case 'ivtAff'
                for i = 1:seq_lengthV
                    [rect c] = calcRectCenter(results.tmplsize, results.res(i,:), 'Color', [1 1 1], 'LineWidth', LineWidth,'LineStyle',LineStyle);
                    rectMat(i,:) = rect;
                    %                     center(i,:) = c;
                end
            case 'L1Aff'
                for i = 1:seq_lengthV
                    [rect c] = calcCenter_L1(results.res(i,:), results.tmplsize);
                    rectMat(i,:) = rect;
                end
            case 'LK_Aff'
                for i = 1:seq_lengthV
                    [corner c] = getLKcorner(results.res(2*i-1:2*i,:), results.tmplsize);
                    rectMat(i,:) = corner2rect(corner);
                end
            case '4corner'
                for i = 1:seq_lengthV
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
        errV = calcRectInt(rectMat(1:seq_lengthV,:),rect_whV(1:seq_lengthV,:));
        errI = calcRectInt(rectMat(1:seq_lengthI,:),rect_whI(1:seq_lengthI,:));

            err = max(errV, errI);
%             err(:,index_algrm) = errV(:,index_algrm);

%         err = (max(errV, errI)+min(errV, errI))/2;
%         rectMat(1,:)
%         rect_anno(1,:)
%         err(1,1)
        errCenterV = sqrt(sum(((center(1:seq_lengthV,:) - centerGTV(1:seq_lengthV,:)).^2),2));
        errCenterI = sqrt(sum(((center(1:seq_lengthI,:) - centerGTI(1:seq_lengthI,:)).^2),2));

            errCenter = min(errCenterV, errCenterI);
%             errCenter(:,index_algrm) = errCenterV(:,index_algrm);

%         errCenter = (max(errCenterV, errCenterI)+min(errCenterV, errCenterI))/2;
%         errCenter(100,1)
        if(isdir(['ERRresults/' name])==0),
            mkdir(['ERRresults/' name]);
        end
        save([['ERRresults/' name] '/' name '_' seq_name '.mat'], 'err','errCenter');
        
        if bPlot            
            h1=figure(1);
%             h1=figure(index_algrm*2-1);
%             plot(err(:,index_algrm),'color', trks{index_algrm}.color,'LineWidth',LineWidth,'LineStyle',LineStyle);
            plot(err,'color',[0,1,0],'LineWidth',LineWidth,'LineStyle',LineStyle);
            hold on 
            
            h2=figure(2);
%             h2=figure(index_algrm*2);
            plot(errCenter,'color', [0,1,0],'LineWidth',LineWidth,'LineStyle',LineStyle);
            hold on
            
        end
    end
    
    if bPlot
        figure(1);
%         figure(index_algrm*2-1);
        axis tight
        set(gca,'fontsize',20);
        
%         xlabel(h1,'string',['# ' seqs{index_seq}],'FontSize',20)
%         ylabel(h1,'string','Coverage/quality','FontSize',20)  
        xlabel(['# ' seqs{index_seq}],'FontSize',20)
        ylabel('Coverage/quality','FontSize',20)  

%         legend(trackerNames,'Orientation','horizontal','Position', [0.20 0.004 0.59 0.05]);
%         legend(trackerNames,'Position', 'Best');
        
%         print(h1, '-depsc', [pathPlot seq_name '_coverage']);
%         imwrite(frame2im(getframe(h1)), [pathPlot seq_name '_coverage.png']);
               
        figure(2);
%         figure(index_algrm*2);
        axis tight;
        set(gca,'fontsize',20);

%         xlabel(h2,'string',['# ' seqs{index_seq}],'FontSize',20)
%         ylabel(h2,'string','Center error','FontSize',20)
        xlabel(['# ' seqs{index_seq}],'FontSize',20)
        ylabel('Center error','FontSize',20)

%         legend(trackerNames,'Position', 'Best');
        
%         print(h2, '-depsc', [pathPlot seq_name '_center']);
%         imwrite(frame2im(getframe(h2)), [pathPlot seq_name '_center.png']);

        pause(0.05);

        clf(h1);
        clf(h2);
    end
    
    aveErrCoverage(index_seq,:) = sum(err)/seq_lengthV;
    errCoverageAll(index_seq,:) = sum(err);
    
    aveErrCenter(index_seq,:) = sum(errCenter)/seq_lengthV;
    errCenterAll(index_seq,:) = sum(errCenter);
    
    lostCount(index_seq,:)=sum(err<thred);
     precisonPlot=precisonPlot+sum(errCenter<=5);
     successPlot=successPlot+sum(err>0.6);
    err = [];
    errV = [];
    errI = [];
    errCenter=[];
    errCenterV = [];
    errCenterI = [];
end
close(h1);
close(h2);
% lenTotalSeq
% aveErrCoverageAll=sum(errCoverageAll)/lenTotalSeq;    %���е��ཻ��

% aveErrCenterAll=sum(errCenterAll)/lenTotalSeq;        %���е����Ĵ���
% precisonPlot
% precisonPlot/lenTotalSeq
% successPlot/lenTotalSeq
% save(['./errAnalysis.mat'], 'aveErrCoverage', 'aveErrCenter', 'aveErrCoverageAll', 'aveErrCenterAll', 'lostCount', 'thred');
% lostRateEachAlg=sum(lostCount)/lenTotalSeq
% lostCount
% sum(lostCount)
