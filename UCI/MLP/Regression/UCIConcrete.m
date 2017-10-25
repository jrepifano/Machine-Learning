clc; clear all;

table = readtable("C:\Users\Jake\Documents\MATLAB\MachineLearning\UCI\Concrete_Data.csv");
X = table2array(table(:,1:8));
X = mapminmax(X);
labels = table2array(table(:,9));
labels = mapminmax(labels);

mlp = feedforwardnet(10);
mlp.layers{1}.transferFcn = 'purelin';
net = train(mlp,X',labels');
%view(net)
y = net(X');
perf = perform(net,y,labels');