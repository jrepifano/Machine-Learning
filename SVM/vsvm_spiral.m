clear all; clc;
data = twospirals(1000, 1000, 0, 0);
spiral1 = data(1:500,1:2);
spiral2 = data(501:1000,1:2);


figure;
hold on
plot(spiral1(:,1),spiral1(:,2),'.'); %plot
plot(spiral2(:,1),spiral2(:,2),'+');
title('Training Data');
hold off

X = data(1:length(data),1:2);
Y = data(1:length(data),3);



vsvmmodel = fitcsvm(X,Y,'Standardize',true,'KernelFunction','RBF','KernelScale','auto');

prediction = predict(vsvmmodel,X);
c1 = [];
c2 = [];
for i = 1:length(X)
    if(prediction(i) == 0)
        c1 = [c1;X(i,1) X(i,2)];
    else
        c2 = [c2;X(i,1) X(i,2)];
    end
end

figure;
hold on
plot(c1(:,1),c1(:,2),'.'); %plot
plot(c2(:,1),c2(:,2),'+');
title('Testing with VSVM, RBF Kernel');
hold off

CVSVMModel = crossval(vsvmmodel);
classLoss = kfoldLoss(CVSVMModel);
fprintf("K-fold loss: " + classLoss);


%DATA GENERATION
function data = twospirals(N, degrees, start, noise)
% Generate "two spirals" dataset with N instances.
% degrees controls the length of the spirals
% start determines how far from the origin the spirals start, in degrees
% noise displaces the instances from the spiral. 
%  0 is no noise, at 1 the spirals will start overlapping

    if nargin < 1
        N = 2000;
    end
    if nargin < 2
        degrees = 570;
    end
    if nargin < 3
        start = 90;
    end
    if nargin < 5
        noise = 0.2;
    end  
    
    deg2rad = (2*pi)/360;
    start = start * deg2rad;

    N1 = floor(N/2);
    N2 = N-N1;
    
    n = start + sqrt(rand(N1,1)) * degrees * deg2rad;   
    d1 = [-cos(n).*n + rand(N1,1)*noise sin(n).*n+rand(N1,1)*noise zeros(N1,1)];
    
    n = start + sqrt(rand(N1,1)) * degrees * deg2rad;      
    d2 = [cos(n).*n+rand(N2,1)*noise -sin(n).*n+rand(N2,1)*noise ones(N2,1)];
    
    data = [d1;d2];
end


