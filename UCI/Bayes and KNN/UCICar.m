clc; clear all;

data = readtable("C:\Users\Jake\Documents\MATLAB\MachineLearning\UCI\car.csv");
bayes = fitcnb(data(:,1:6),data(:,7));
knn = fitcknn(data(:,1:6),data(:,7));

bayescross = crossval(bayes);
bayesloss = kfoldLoss(bayescross);

knncross = crossval(knn);
knnloss = kfoldLoss(knncross);
