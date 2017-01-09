function [points]=Determine_HarrisCorner(I1)
%% Initialize Variables 
Sigma=1.5;
Thres =0.0005;
Thres_Discret=5;
Scaler=0.05;
W=5;

%% Filter image with Gaussian to reduce noise
I_GRAY_opt = I1;


I_opt = imgaussfilt(I_GRAY_opt,Sigma);
[row, col]=size(I_opt);



%% using a discret operator 
operator = [-1 0 1;-1 0 1;-1 0 1];
Ix_opt = conv2(I_opt, operator, 'same');
Iy_opt = conv2(I_opt, operator', 'same');

Ixy_opt=Ix_opt .* Iy_opt;

I_good_opt=zeros(row,col);
R_m_opt=zeros(row,col);

for x=1:(row-W),
   for y=1:(col-W),

       % Filter the gradient with Gaussian filter and Construct a window 
       Gaussian_Ix=imgaussfilt(Ix_opt,Sigma);
       Gaussian_Iy=imgaussfilt(Iy_opt,Sigma);
       Gaussian_Ixy=imgaussfilt(Ixy_opt,Sigma);  
       
       temp_Ix=Gaussian_Ix((x):(x+W),(y):(y+W));
       temp_Iy=Gaussian_Iy((x):(x+W),(y):(y+W));
       temp_Ixy=Gaussian_Ixy((x):(x+W),(y):(y+W));
       
       
       C_opt = [sum(sum(temp_Ix .^2)) sum(sum(temp_Ixy .^2)); sum(sum(temp_Ixy .^2)) sum(sum(temp_Iy .^2))];

       R_opt = (det(C_opt) - Scaler * (trace(C_opt) ^ 2));
       % Solve for ?s
       R_m_opt(x,y)=R_opt;


   end
end

% Label the Corner with and Remove the duplicated label using a window
for x=(1+5):(row-5),
   for y=(1+5):(col-5),
       if (R_m_opt(x,y)==max(max(R_m_opt(x-5:x+5,y-5:y+5))) && R_m_opt(x,y) > Thres_Discret )
            I_good_opt(x, y) = 125;
            I_GRAY_opt = insertMarker(I_GRAY_opt,[y x]);
       
       end
   end
end

points=I_GRAY_opt;


figure (25)
imshow(I_good_opt);
title('Corner Detected with Discret Operators');

figure (26);
imshow(I_GRAY_opt);
title('Mapped to Orignial Image with Discret Operators');




