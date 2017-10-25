clc; clear all;

table = readtable("C:\Users\Jake\Documents\MATLAB\MachineLearning\UCI\computerhardware.csv");
X = table2array(table(:,3:9));

labels = table2array(table(:,10));



mlp = feedforwardnet(10);
mlp.layers{1}.transferFcn = 'purelin';
net = train(mlp,X',labels');
view(net)
y = net(X');
perf = perform(net,labels,y);