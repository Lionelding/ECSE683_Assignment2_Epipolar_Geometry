function [P] = getExtinsic(P_4possible, Intrinsic1,Intrinsic2, X)

% Import matched points in image coordinates
x_left = X(:,1);
x_right = X(:,2);

% define the mid-step and output variables
P_cameraMatrix = [eye(3),zeros(3,1)];
P = Intrinsic1*P_cameraMatrix;
x_left_hat = inv(Intrinsic1)*x_left;
Dim3_X = zeros(4,4);
Result_depth = zeros(4,2);

for i=1:4
    % Convert the first point
    x_right_hat = inv(Intrinsic2)*x_right;

    % A is constructed here
    A = [P_cameraMatrix(3,:).*x_left_hat(1,1)-P_cameraMatrix(1,:); P_cameraMatrix(3,:).*x_left_hat(2,1)-P_cameraMatrix(2,:); P_4possible(3,:,i).*x_right_hat(1,1)-P_4possible(1,:,i); P_4possible(3,:,i).*x_right_hat(2,1)-P_4possible(2,:,i)];

    % Normalize A
    A_1 = sqrt(sum(A(1,:).*A(1,:)));
    A_2 = sqrt(sum(A(2,:).*A(2,:)));
    A_3 = sqrt(sum(A(1,:).*A(1,:)));
    A_4 = sqrt(sum(A(1,:).*A(1,:))); 
    A_norm = [A(1,:)/A_1; A(2,:)/A_2; A(3,:)/A_3; A(4,:)/A_4];

    % SVD if A_norm
    [U,S,V] = svd(A_norm);
    Dim3_X(:,i) = V(:,end);
    % In the second image, put the result in the Result_depth
    initial = P_4possible(:,:,i)*Dim3_X(:,i); temp_W = initial(3);
    T = Dim3_X(end,i);
    temp_m = sqrt(sum(P_4possible(3,1:3,i).*P_4possible(3,1:3,i)));
    Result_depth(i,1) = (sign(det(P_4possible(:,1:3,i)))*temp_W)/(T*temp_m);

    % In the first image, put the result in the Result_depth
    initial = P_cameraMatrix(:,:)*Dim3_X(:,i);
    temp_W = initial(3); T = Dim3_X(end,i);
    temp_n = sqrt(sum(P_cameraMatrix(3,1:3).*P_cameraMatrix(3,1:3)));
    Result_depth(i,2) = (sign(det(P_cameraMatrix(:,1:3)))*temp_W)/(T*temp_n);

end;

% Check which solution with the positive answer
if(Result_depth(1,1)>0 && Result_depth(1,2)>0)
    P = P_4possible(:,:,1);
elseif(Result_depth(2,1)>0 && Result_depth(2,2)>0)
    P = P_4possible(:,:,2);    
elseif(Result_depth(3,1)>0 && Result_depth(3,2)>0)
    P = P_4possible(:,:,3);
elseif(Result_depth(4,1)>0 && Result_depth(4,2)>0)
    P = P_4possible(:,:,4);
end;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    