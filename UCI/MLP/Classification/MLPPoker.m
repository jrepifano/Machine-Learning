clc; clear all;

table = readtable("C:\Users\Jake\Documents\MATLAB\MachineLearning\UCI\poker.csv");
X = table2array(table(1:500,1:10));

labels = table2array(table(1:500,11));
labels = convertlabels(labels);

mlp = feedforwardnet(20);
net = train(mlp,X',labels');
%view(net)
y = net(X');
perf = perform(net,labels',y);

plotconfusion(labels', y, 'Classifications and Missclassifications');



function x = convertlabels(labels)
flabels = zeros(500,10);
for i = 1:length(labels)
   y = labels(i)+1;
   flabels(i,y) = flabels(i,y)+1;
end
x = flabels;
end
