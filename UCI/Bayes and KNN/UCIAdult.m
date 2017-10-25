clc; clear all;

data = readtable("C:\Users\Jake\Documents\MATLAB\MachineLearning\UCI\adult.csv");
bayes = fitcnb(data(:,1:14),data(:,15));
%knn = fitcknn(data(:,1:14,data(:,15));

bayescross = crossval(bayes);
bayesloss = kfoldLoss(bayescross);

% knncross = crossval(knn);
% knnloss = kfoldLoss(knncross);
