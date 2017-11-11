clc;
clear all;
x = mvnrnd([2 5], [1 1], 100); %OG data
y = mvnrnd([4 3], [1 1], 100);

z = vertcat(x,y);


net = mvnrnd([3 3], [1 1], 9);

hold on
plot(x(:,1),x(:,2),'.'); %plot
plot(y(:,1),y(:,2),'+');
title('SOM');
plot(net(:,1),net(:,2),'x','linewidth',8); %plot
hold off

z = z';
net = net';


numberofepochs = 10;                         %set max epoch

neighborhood = 3;                           %initial neighborhood value

count = 0;                                  %init counter
neighborcounter = 0;

trainingrate = 0.05;                         %init training rate

% dist = pdist([z(:,1) net(:,1)]);

while count < numberofepochs
    for i = 1:length(z)                     %test every point
        dist = [];
        for j = 1:length(net)               %test every neuron
            dist = [dist; (sqrt((net(1,j)-z(1,i)).^2+(net(2,j)-z(2,i)).^2))]; %distance from point to every neuron
        end
        BMU = findBMU(dist);                %returns index of the closest neuron
        if(neighborhood > 1)
            neighbors = knnsearch(dist,dist(BMU),'K',neighborhood); %creates matrix of knns including BMU
        end
        for k = 1:length(neighbors)
            nettoupdate = net(:,neighbors(k));
            newnet = net(neighbors(:,k)) + trainingrate*(z(:,i) - net(:,neighbors(k)));
            net(:,neighbors(k)) = newnet;
        end
    end
    
    neighborcounter = neighborcounter + 1;
    count = count + 1;                      %increment epoch
    if(neighborhood > 1 && neighborcounter == 4)                    %decrease neighborhood size
        neighborhood = neighborhood - 1;
        neighborcounter = 0;
    end
end

net = net';
figure;
plot(net(:,1),net(:,2),'.');

function x = findBMU(dist)                  %retrns index of closest neuron
minima = min(dist);
for i = 1:length(dist)
   if(dist(i) == minima)
       x = i;
       break;
   end
end
end