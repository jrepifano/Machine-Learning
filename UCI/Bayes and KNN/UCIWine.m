clc; clear all;

data = readtable("C:\Users\Jake\Documents\MATLAB\MachineLearning\UCI\wine.csv");
bayes = fitcnb(data(:,2:14),data(:,1));
knn = fitcknn(data(:,2:14),data(:,1));

bayescross = crossval(bayes);
bayesloss = kfoldLoss(bayescross);

knncross = crossval(knn);
knnloss = kfoldLoss(knncross);
