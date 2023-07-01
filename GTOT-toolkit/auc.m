function auc=auc(FPR,TPR);
% given true positive rate and false positive rate calculates the area under the curve
% true positive are on the y-axis and false positives on the x-axis
% sum rectangular area between all points
% example: auc=auc(FPR,TPR);
[x2,inds]=sort(FPR);
x2=[x2,1];  % the trick is in inventing a last point 1,1
y2=TPR(inds); 
y2=[y2,1];
xdiff=diff(x2);
%xdiff
xdiff=[x2(1),xdiff];
auc1=sum(y2.*xdiff); % upper point area
auc2=sum([0,y2([1:end-1])].*xdiff); % lower point area
auc=mean([auc1,auc2]);
end

