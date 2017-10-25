clc; clear all;

table = readtable("C:\Users\Jake\Documents\MATLAB\MachineLearning\UCI\iris.csv");
X = table2array(table(:,1:4));

labels = [ones(50,1);2*ones(50,1);3*ones(50,1)];

mlp = feedforwardnet(10);
net = train(mlp,X',labels');
view(net)
y = net(X');
perf = perform(net,labels,y);