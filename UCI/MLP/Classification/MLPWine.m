clc; clear all;

table = readtable("C:\Users\Jake\Documents\MATLAB\MachineLearning\UCI\wine.csv");
X = table2array(table(:,2:14));

labels = table2array(table(:,1));

mlp = feedforwardnet(10);
net = train(mlp,X',labels');
view(net)
y = net(X');
perf = perform(net,labels,y);