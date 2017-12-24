clc; clear all;

cat = load('cat.mat');
cat = getfield(cat,'intData');
cat = double(cat);

mouse = load('mouse.mat');
mouse = getfield(mouse,'intData');
mouse = double(mouse);

dog = load('dog.mat');
dog = getfield(dog,'intData');
dog = double(dog);

anolelizard = load('anolelizard.mat');
anolelizard = getfield(anolelizard,'intData');
anolelizard = double(anolelizard);

platypus = load('platypus.mat');
platypus = getfield(platypus,'intData');
platypus = double(platypus);

data = [mouse;dog;cat;anolelizard;platypus];

net = selforgmap([3 3],500,3,'gridtop','linkdist');
net.trainParam.epochs=5000;
net = train(net,data);
plotsompos(net,data);

