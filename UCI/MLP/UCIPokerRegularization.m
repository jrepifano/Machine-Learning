clc; clear all;

table = readtable("C:\Users\Jake\Documents\MATLAB\MachineLearning\UCI\poker.csv");
X = table2array(table(:,1:10));

labels = table2array(table(:,11));

mlp = feedforwardnet(10,'trainbr');
mlp.divideFcn = '';
net = train(mlp,X',labels');
view(net)
y = net(X');
perf = perform(net,labels,y);