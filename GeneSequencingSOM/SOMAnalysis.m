clc; clear all;

cat = load('cat.mat');
cat = getfield(cat,'intData');
cat = double(cat);

mouse = load('mouse.mat');
mouse = getfield(mouse,'intData');
mouse = mouse(:,1:21297);
mouse = double(mouse);

dog = load('dog.mat');
dog = getfield(dog,'intData');
dog = dog(:,1:21297);
dog = double(dog);

anolelizard = load('anolelizard.mat');
anolelizard = getfield(anolelizard,'intData');
anolelizard = anolelizard(:,1:21297);
anolelizard = double(anolelizard);

platypus = load('platypus.mat');
platypus = getfield(platypus,'intData');
platypus = platypus(:,1:21297);
platypus = double(platypus);

data = [mouse;dog;cat;anolelizard;platypus];

net = selforgmap([5 5]);
net = train(net,data);
y = net(data);
classes = vec2ind(y);
plotsompos(net,data);

