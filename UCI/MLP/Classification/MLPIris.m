clc; clear all;

table = readtable("C:\Users\Jake\Documents\MATLAB\MachineLearning\UCI\iris.csv");
X = table2array(table(:,1:4));

labels = [ones(50,1);2*ones(50,1);3*ones(50,1)];
labels = convertlabels(labels);

mlp = feedforwardnet(10);
net = train(mlp,X',labels');
%view(net)
y = net(X');
perf = perform(net,labels',y);
plotconfusion(labels', y, 'Classifications and Missclassifications');


function x = convertlabels(labels)
flabels = zeros(150,3);
for i = 1:length(labels)
   y = labels(i);
   flabels(i,y) = flabels(i,y)+1;
end
x = flabels;
end

function x = converttestlabels(labels)
flabels = zeros(10000,10);
for i = 1:length(labels)
   y = labels(i)+1;
   flabels(i,y) = flabels(i,y)+1;
end
x = flabels;
end