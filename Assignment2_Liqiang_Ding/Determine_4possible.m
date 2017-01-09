function P4 = Determine_4possible(E)
% Calculate four possible combination of R and T

% SVD of Elementary matrix
[U,S,V] = svd(E);

%W
W = [0,-1,0;...
    1,0,0;...
    0,0,1];        

Z= [0,1,0;-1,0,0;0,0,0];

% Store the output all four possible solutions.
P4 = zeros(3,4,4);
R1 = U*W*V';
R2 = U*W'*V';
T1 = U(:,3);
T2 = -U(:,3);

P4(:,:,1) = [R1, T1]; %the first possible combination
P4(:,:,2) = [R1, T2]; %the second possible combination
P4(:,:,3) = [R2, T1]; %the third possible combination
P4(:,:,4) = [R2, T2]; %the fourth possible combination
  

% Reference: http://isit.u-clermont1.fr/~ab/Classes/DIKU-3DCV2/Handouts/Lecture16.pdf
end

