clear all; clc;
X = mvnrnd([2 5], [1 1], 100); %OG data
Y = mvnrnd([4 3], [1 1], 100);

Z = vertcat(X,Y);


neurons = mvnrnd([3 3], [1 1], 9);

figure
hold on
plot(X(:,1),X(:,2),'.'); %plot
plot(Y(:,1),Y(:,2),'+');
title('SOM Initial');
plot(neurons(:,1),neurons(:,2),'x','linewidth',8); %plot

Z = Z';
neurons = neurons';

learningrate = 0.05;

epochs = 200;

while(epochs > 1)
BMU = [];
for i = 1:length(Z)
   dist = [];
   for j = 1:length(neurons)
   dist = [dist; (sqrt((neurons(1,j)-Z(1,i)).^2+(neurons(2,j)-Z(2,i)).^2))];
   end
   BMU = [BMU;findBMU(dist)];
end

for j = 1:length(neurons)
winners = [];
    for k = 1:length(BMU)
       if(j == BMU(k))
       winners = [winners;Z(1,k) Z(2,k)]; 
       end
    end
    if(isempty(winners) == 0)
        if(size(winners,1) > 1)
            mu = mean(winners);
        else
            mu = winners;
        end
    distance = [(neurons(1,j)-mu(1)) (neurons(2,j)-mu(2))];
    update = neurons(:,j)' - learningrate*distance;
    neurons(:,j) = update;
    end
end
epochs = epochs - 1;
end

neurons = neurons';

figure
hold on
plot(X(:,1),X(:,2),'.'); %plot
plot(Y(:,1),Y(:,2),'+');
title('SOM final');
plot(neurons(:,1),neurons(:,2),'x','linewidth',8); %plot


function x = findBMU(dist)                  %retrns index of closest neuron
minima = min(dist);
for i = 1:length(dist)
   if(dist(i) == minima)
       x = i;
   end
end
end
