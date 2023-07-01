
% D:\MultimodalDataset\dataset\dataset\
basePath='D:\MultimodalDataset\dataset\dataset\';
directory=dir(basePath);
directory={directory.name};
directory=cellstr(directory(3:end));

for k=1:size(directory,2),
directory(k)
video_path_v=[basePath directory{k} '/v/'];
video_path_i=[basePath directory{k} '/i/'];
video_path_v
video_path_i
f_v = fopen([video_path_v  'groundTruth.txt']);
ground_truth_v = textscan(f_v, '%f %f %f %f');
fclose(f_v);
ground_truth_v = cat(2, ground_truth_v{:});
f_i = fopen([video_path_i  'groundTruth.txt']);
ground_truth_i = textscan(f_i, '%f %f %f %f');
fclose(f_i);
% ground_truth_i{:}
ground_truth_i = cat(2, ground_truth_i{:});
% ground_truth_v(4,:)
% size(ground_truth_i)
% size(ground_truth_v)
saveFile_v=[basePath directory{k} '/groundTruth_v.txt'];
saveFile_i=[basePath directory{k} '/groundTruth_i.txt'];

saveFile=[basePath directory{k} '/groundTruth.txt'];

f_vv = fopen(saveFile_v,'w');
f_ii = fopen(saveFile_i,'w');
fvi=fopen(saveFile,'w');
assert(size(ground_truth_v,1)==size(ground_truth_i,1));
for i=1:size(ground_truth_v,1),
    x1_v=ground_truth_v(i,1);y1_v=ground_truth_v(i,2);x2_v=ground_truth_v(i,3);y2_v=ground_truth_v(i,4);
    x1_i=ground_truth_i(i,1);y1_i=ground_truth_i(i,2);x2_i=ground_truth_i(i,3);y2_i=ground_truth_i(i,4);
    
    if(x1_v==0&&x2_v==0&&y1_v==0&&y2_v==0),
        if(x1_i==0&&x2_i==0&&y1_i==0&&y2_i==0),%两种模态下都没有
            ground_truth_v(i,1)=ground_truth_v(i-1,1);
            ground_truth_v(i,2)=ground_truth_v(i-1,2);
            ground_truth_v(i,3)=ground_truth_v(i-1,3);
            ground_truth_v(i,4)=ground_truth_v(i-1,4);
        else
            ground_truth_v(i,1)=ground_truth_i(i,1);
            ground_truth_v(i,2)=ground_truth_i(i,2);
            ground_truth_v(i,3)=ground_truth_i(i,3);
            ground_truth_v(i,4)=ground_truth_i(i,4);
        end
                
    end
    
    
    if(x1_i==0&&x2_i==0&&y1_i==0&&y2_i==0),
        if(x1_v==0&&x2_v==0&&y1_v==0&&y2_v==0),%两种模态下都没有
            ground_truth_i(i,1)=ground_truth_i(i-1,1);
            ground_truth_i(i,2)=ground_truth_i(i-1,2);
            ground_truth_i(i,3)=ground_truth_i(i-1,3);
            ground_truth_i(i,4)=ground_truth_i(i-1,4);
        else
            ground_truth_i(i,1)=ground_truth_v(i,1);
            ground_truth_i(i,2)=ground_truth_v(i,2);
            ground_truth_i(i,3)=ground_truth_v(i,3);
            ground_truth_i(i,4)=ground_truth_v(i,4);
        end
                
    end
    fprintf(fvi,'%5.2f ',(ground_truth_v(i,1)+ground_truth_i(i,1))/2);fprintf(fvi,'%5.2f ',(ground_truth_v(i,2)+ground_truth_i(i,2))/2);fprintf(fvi,'%5.2f ',(ground_truth_v(i,3)+ground_truth_i(i,3))/2);fprintf(fvi,'%5.2f\n',(ground_truth_v(i,4)+ground_truth_i(i,4))/2);
    fprintf(f_vv,'%d ',ground_truth_v(i,1));fprintf(f_vv,'%d ',ground_truth_v(i,2));fprintf(f_vv,'%d ',ground_truth_v(i,3));fprintf(f_vv,'%d\n',ground_truth_v(i,4));
    fprintf(f_ii,'%d ',ground_truth_i(i,1));fprintf(f_ii,'%d ',ground_truth_i(i,2));fprintf(f_ii,'%d ',ground_truth_i(i,3));fprintf(f_ii,'%d\n',ground_truth_i(i,4));
    
    
end
fclose(f_vv);fclose(f_ii);fclose(fvi);
end
