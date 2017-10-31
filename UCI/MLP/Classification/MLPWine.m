clc; clear all;

table = readtable("C:\Users\Jake\Documents\MATLAB\MachineLearning\UCI\wine.csv");
X = table2array(table(:,2:14));

labels = table2array(table(:,1));
labels = convertlabels(labels);

mlp = feedforwardnet(10);
net = train(mlp,X',labels');
y = net(X');
perf = perform(net,labels',y);

plotconfusion(labels', y, 'Classifications and Missclassifications');

function x = convertlabels(labels)
flabels = zeros(178,3);
for i = 1:length(labels)
   y = labels(i);
   flabels(i,y) = flabels(i,y)+1;
end
x = flabels;
end

