clc; clear all;

data = load('k8.mat');
data = data.data;

net = selforgmap([20 20],500,3,'gridtop','linkdist');
net.trainParam.epochs=50;
net = train(net,data);
plotsompos(net,data);

