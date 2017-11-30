clc; clear all;
imageOG = imread('C:\Users\Jake\Documents\GitHub\Machine-Learning\Dimensional-Reduction\PCA\yalefaces\yalefaces\subject01.happy.gif');
imageOG = im2double(imageOG);

[M,N] = size(imageOG);

meanim = mean(imageOG,2);

repmatim = repmat(meanim,1,N);

image = imageOG - repmatim;

covariance = cov(image);

[V,D] = eig(covariance,'vector');

K3 = V(:,318:320);

outputim = K3.*K3'.*imageOG;