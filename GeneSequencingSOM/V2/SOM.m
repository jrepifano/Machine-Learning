clc; clear all;

% tic
% 
% labels = load('labels.mat');
% labels = labels.labels;
% labels = convertlabels(labels);
% 
% performance = [];
k = [2;4;6];

for i = 1:4
    
data = load(['nk'...
    num2str(k(i)) '.mat']);
data = data.normalizedData;
       
net = selforgmap([20 20],0,5,'gridtop','linkdist');
net.trainParam.epochs=5;
net = train(net,data);
y = net(data);
plotsompos(net,data);


% CP = classperf(labels', y);
% 
% x = CP.specificity;
% performance = [performance;x];
end

toc

function x = convertlabels(labels)
flabels = zeros(10678, 2);
for i = 1:length(labels)
   y = labels(i);
   flabels(i,y) = flabels(i,y)+1;
end
x = flabels;
end

% 
% performance = load('performance.mat');
% performance = performance.performance;
% performance = performance*100;
% 
% bar(k,performance);
% title('Classification of Bacteria vs Archaea');
% xlabel('Number of K-mers');
% ylabel('Performance');