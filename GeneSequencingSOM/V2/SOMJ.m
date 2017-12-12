clear all; clc;

data = load('k6.mat');
data = data.data;

com = mean(data,1);

neurons = mvnrnd(com,ones(1,length(com)),100);

neurons = neurons';

learningrate = 0.05;

epochs = 200;

while(epochs > 1) %train for set epoch
BMU = [];
for i = 1:length(Z) %for each input vector
   dist = [];
   for j = 1:length(neurons) %for each neuron
   dist = [dist; (sqrt((neurons(1,j)-Z(1,i)).^2+(neurons(2,j)-Z(2,i)).^2))];
   %^makes a matrix of the distances from each neuron to the input vector
   end
   BMU = [BMU;findBMU(dist)]; %Calls fuction to find BMU for that iteration
end

%update loop
for j = 1:length(neurons) 
winners = [];
    for k = 1:length(BMU)
    %finds all input vectors for which each neuron is a winner
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
    %neurons move towards the mean of all winning points according to the
    %update rule and the learning rate set above.
    end
end
epochs = epochs - 1; %decrement number of epochs left
end

neurons = neurons';

figure
hold on
plot(X(:,1),X(:,2),'.'); %plot
plot(Y(:,1),Y(:,2),'+');
title('SOM final');
plot(neurons(:,1),neurons(:,2),'x','linewidth',8); %plot


function x = findBMU(dist)  %retrns index of closest neuron
minima = min(dist);
for i = 1:length(dist)
   if(dist(i) == minima)
       x = i;
   end
end
end
