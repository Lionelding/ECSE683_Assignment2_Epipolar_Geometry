clc;clear;close all;
%% Import Images
load stereoPointPairs

I1 = rgb2gray(imread('Dinosaur_left.jpg'));
I2 = rgb2gray(imread('Dinosaur_right.jpg'));

I1=im2double(I1);
I2=im2double(I2);

[row, col]=size(I1);
%% Use Correlation Based Approach
W_size=9;
disp_min=0;
disp_max=16;
%[dispMap, maxIndex]=Correlation_base_approach(I1,I2, W_size, disp_min, disp_max);


%% Use Feature Based Approach
[Location_left, Location_right]=Feature_base_approach(I1,I2);
z_distance=ones(13,1);

Location_left_left=Location_left.Location;
Location_right_right=Location_right.Location;

Location_left_left_full=[Location_left_left z_distance];
Location_right_right_full=[Location_right_right z_distance];

%% Determine the F, fundamental matrix
% Determine the position of the epipoles in pixel coordinates
imageSize = [row col];

% Manual 1
F1=Caculate_Fundamental(matchedPoints1, matchedPoints2);
[isIn_left1,epipole_left1] = isEpipoleInImage(F1,imageSize);
[isIn_right1,epipole_right1] = isEpipoleInImage(F1',imageSize);
inliers=logical([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]');

% Built-in function
%[F3,inliers,status] = estimateFundamentalMatrix(matchedPoints1, matchedPoints2,'Method','Norm8Point');
%[isIn_left3,epipole_left3] = isEpipoleInImage(F3,imageSize);
%[isIn_right3,epipole_right3] = isEpipoleInImage(F3',imageSize);

F=F1;

%% plot the epipolar lines in the left image
% 
figure(10);
subplot(121);
imshow(I1);
title('Inliers and Epipolar Lines in First Image'); hold on;
plot(Location_left_left(inliers(4:10,:),1),Location_left_left(inliers(4:10,:),2),'go')

%Manually select the best 5
%plot(Location_left_left(9,1),Location_left_left(9,2),'go');
%plot(Location_left_left(8,1),Location_left_left(8,2),'go');
%plot(Location_left_left(1,1),Location_left_left(1,2),'go');
%plot(Location_left_left(12,1),Location_left_left(12,2),'go');
%plot(Location_left_left(6,1),Location_left_left(6,2),'go');

epiLines1 = epipolarLine(F',Location_left_left(inliers(4:10,:),:));
points1 = lineToBorderPoints(epiLines1,size(I1));
line(points1(:,[1,3])',points1(:,[2,4])');


subplot(122);
imshow(I2);
title('Inliers and Epipolar Lines in Second Image'); hold on;
plot(Location_right_right(inliers(4:10,:),1),Location_right_right(inliers(4:10,:),2),'go')

epiLines2 = epipolarLine(F,Location_right_right(inliers(4:10,:),:));
points2 = lineToBorderPoints(epiLines2,size(I2));
line(points2(:,[1,3])',points2(:,[2,4])');
truesize;
%}


%% Form the intrinsic parameter matrix
skew=0;
% focal_pixel = (focal_mm / sensor_width_mm) * image_width_in_pixels
focal=6616/95*1900;
Intrinsic=[focal,skew,986;0,focal,1057;0,0,1];
E=Intrinsic'*F*Intrinsic;

Possible_Extrinsic = Determine_4possible(E);

inX = [Location_left_left_full(1,:)' Location_right_right_full(1,:)'];
Extrinsic = getExtrinsic(Possible_Extrinsic, Intrinsic, Intrinsic, inX);
T=Extrinsic(:,4);
R=Extrinsic(:,1:3);


%% Rectify the image
e1 = T./((T(1)^2+T(2)^2+T(3)^2)^0.5);
e2 = 1/((T(1)^2+T(2)^2)^0.5)*[-T(2),T(1),0]';
e3 = cross(e1,e2);

R_rect=[e1;e2;e3];
R_rect=reshape(R_rect,3,3)';
R_left=R_rect;
R_right=R*R_rect;

Rect_left=uint8(zeros(row,col));
focal=focal/1000;
for i=1:row
    for j=1:col
       temp_left=R_left*[i,j,focal]';
       cor_left2=focal/temp_left(3)*temp_left';
       cor_left=floor(cor_left2);
       Rect_left(cor_left(1),abs(cor_left(2))+1)=I1(i,j); 
    end
end
%}



%% Reconstruct the image 
%stereoParams = stereoParameters(Intrinsic,Intrinsic,Extrinsic(:,1:3),Extrinsic(:,4))

%Get 3D Data using Direct Linear Transform(Linear Triangular method)
%{
Xw = Triangulation(double(Location_left_left_full)',Intrinsic*[eye(3) zeros(3,1)], double(Location_right_right_full)',Intrinsic*Extrinsic);
xx=Xw(1,:);
yy=Xw(2,:);
zz=Xw(3,:);

figure(50);
plot3(xx, yy, zz, 'r+');
%}

