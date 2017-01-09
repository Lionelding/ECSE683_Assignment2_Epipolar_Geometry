function [F]=Caculate_Fundamental(mpoint1,mpoint2)

% Parse the input and set up the varibale
len = length(mpoint1);
mpoint1=[mpoint1(:,1) mpoint1(:,2) ones(len,1)];
mpoint2=[mpoint2(:,1) mpoint2(:,2) ones(len,1)];
%image width
Width = 1900; 
%image height
Height = 1450; 

% Centroid normalization
NormalC=[2/Width 0 -1; ...
    0 2/Height -1; ...
    0   0   1];

% Data Centroid
x1=NormalC*mpoint1'; x2=NormalC*mpoint2';
x1=[x1(1,:)' x1(2,:)'];  
x2=[x2(1,:)' x2(2,:)']; 

% Af=0 
A=[x1(:,1).*x2(:,1) ...
  x1(:,2).*x2(:,1) ... 
  x2(:,1) ...
  x1(:,1).*x2(:,2) ...
  x1(:,2).*x2(:,2) ...
  x2(:,2) ...
  x1(:,1) ...
  x1(:,2), ...
  ones(len,1)];

% Get F matrix
[U D V] = svd(A);
F=reshape(V(:,9), 3, 3)';
% make rank 2 by adjusting the D
[U D V] = svd(F);
F=U*diag([D(1,1) D(2,2) 0])*V';
% Denormalize and return F 
F = NormalC'*F*NormalC;
