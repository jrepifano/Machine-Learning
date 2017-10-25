clc; clear all;

data = readtable("C:\Users\Jake\Documents\MATLAB\MachineLearning\UCI\iris.csv");
bayes = fitcnb(data(:,1:4),data(:,5));
knn = fitcknn(data(:,1:4),data(:,5));

bayescross = crossval(bayes);
bayesloss = kfoldLoss(bayescross);

knncross = crossval(knn);
knnloss = kfoldLoss(knncross);
