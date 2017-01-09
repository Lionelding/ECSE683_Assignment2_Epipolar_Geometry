function draw_epipolar(left_x, left_y)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function takes as argument the (x,y) coordinate of the LEFT
% image and plots its corresponding epipolar line on the RIGHT and  
% the left image
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Hard coding the fundamental matrix FM

FM=[  0.0001   -0.0437   13.3897
      0.0429    0.0033  -21.4157
     -12.1830   22.0779 -999.3629];

close all;
left_image  = double(rgb2gray(imread('rodin0020.jpg')));
right_image = double(rgb2gray(imread('rodin0021.jpg')));

[m n] = size(left_image);
 
str1 = sprintf('Left Image point: %d %d',left_x,left_y); 
str2 = sprintf('Corresponding Epipolar Line on Right Image');

figure,imagesc(left_image); colormap(gray); title(str1); axis image;
figure,imagesc(right_image); colormap(gray); title(str2); axis image;

% Start plotting:

figure(1);    
hold on;
plot(left_x, left_y, 'r*'); 

% Getting the epipolar line on the RIGHT image:

left_P = [left_x; left_y; 1];
right_P = FM*left_P;
right_epipolar_x = 1:2*m;

% Using the eqn of line: ax+by+c=0; y = (-c-ax)/b
right_epipolar_y = (-right_P(3)-right_P(1)*right_epipolar_x)/right_P(2);

figure(2); hold on; plot(right_epipolar_x, right_epipolar_y, 'r');


% Now finding the other epipolar line on the left image itself:
    
% We know that left epipole is the 3rd column of V.
% We get V from svd of F. F=UDV'
[FU, FD, FV] = svd(FM);
left_epipole = FV(:,3);
left_epipole = left_epipole/left_epipole(3);

% Hence using the left epipole and the given input point on left
% image we plot the epipolar line on the left image
left_epipolar_x = 1:2*m;
left_epipolar_y = left_y + (left_epipolar_x-left_x)*(left_epipole(2)-left_y)/(left_epipole(1)-left_x);
        
figure(1); hold on; plot(left_epipolar_x, left_epipolar_y, 'r');

