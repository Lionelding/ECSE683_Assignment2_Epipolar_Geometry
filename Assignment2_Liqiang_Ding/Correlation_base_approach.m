function [dispMap, maxIndex]=Correlation_base_approach(I1, I2, W, distance_minimun, distance_maximum)

%Find the size of the image 
[row_left,col_left] = size(I1);
[row_right,col_right] = size(I2);
dispMap=zeros(row_left, col_left);
win=(W-1)/2;

%Implement the Algorithm CORR_MATCHING
for(i=1+win:1:row_left-win)
    for(j=1+win:1:col_left-win-distance_maximum)
        temp_SSD = 65532;
        temp=0.0;match = distance_minimun;
        for(distance_range=distance_minimun:1:distance_maximum)
            result_ssd=0.0;
            for(a=-win:1:win)
                for(b=-win:1:win)
                    if (j+b+distance_range <= col_left)
                        temp=I2(i+a,j+b)-I1(i+a,j+b+distance_range);
                        temp=temp*temp; result_ssd=result_ssd+temp;
                        %{
                        i j a ab
                        %}
                    end
                end
            end
            if (temp_SSD > result_ssd)
                temp_SSD = result_ssd;
                match = distance_range;
            end
        end
        dispMap(i,j) = match;
    end
end

%return the indices of the largest values 
sortedValues = unique(dispMap(:));          %% Unique sorted values
maxValues = sortedValues(end-0:end);        %% Get the 5 largest values
maxIndex = ismember(dispMap,maxValues);     %% Get a logical index of all values
                                      

%increase the contrast in the intensity 
dispMap=uint8(dispMap.*20);

%{
for i=1:row
    for j=1:col
        
        if maxIndex(i,j)==1
            I2 = insertMarker(I2,[j i]);
        end
        

    end
end

figure(250)
imshow(I2);
%}

figure(5)
imshow(dispMap);
title('Disparity Map');
%Backup_left=0;
%Backup_right=0;
