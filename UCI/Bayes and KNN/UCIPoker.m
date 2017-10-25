clc; clear all;

data = readtable("C:\Users\Jake\Documents\MATLAB\MachineLearning\UCI\poker.csv");
bayes = fitcnb(data(:,1:10),data(:,11));
knn = fitcknn(data(:,1:10),data(:,11));

bayescross = crossval(bayes);
bayesloss = kfoldLoss(bayescross);

knncross = crossval(knn);
knnloss = kfoldLoss(knncross);
