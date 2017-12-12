clc; clear all;

data = load('k4.mat');
data = data.data;

net = selforgmap([2 2],0,5,'gridtop','linkdist');
net.trainParam.epochs=5;
net = train(net,data);
y = net(data);
plotsompos(net,data);

plotconfusion(y,y);