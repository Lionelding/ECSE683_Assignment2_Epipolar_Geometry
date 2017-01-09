%% Use Corner detector to detector points
function [matchedPoints1, matchedPoints2]=Feature_base_approach(I1,I2)

%Using Matlab built-in function to detect corners
points1 = detectHarrisFeatures(I1);
points2 = detectHarrisFeatures(I2);

%Using Manually implemented function to detect corners
%points3 =Determine_HarrisCorner(I1)
%points4 =Determine_HarrisCorner(I2)


[features1,valid_points1] = extractFeatures(I1,points1);
[features2,valid_points2] = extractFeatures(I2,points2);

indexPairs = matchFeatures(features1,features2);

% Calculate matching points
matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

%location_left=matchedPoints1.Location;
%location_right=matchedPoints2.Location;
%location_left=matchedPoints1;
%location_right=matchedPoints2;



figure(10); 
showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2, 'montage');
title('Matched Point using Feature Based Method')