clear all;clc;

w1 = mvnrnd([2 10], [1 1], 100); %OG data
w2 = mvnrnd([7 3], [1 1], 100);

x1 = w1(1:70,1:2); %training data = 70% of d1
x2 = w2(1:70,1:2);

z1 = w1(71:100,1:2); %testing data = 30% of d1
z2 = w2(71:100,1:2);

z = vertcat(z1,z2); %concatenate testing data into 1 matrix

meanx1 = mean(x1); %calculate averages for each class
meanx2 = mean(x2);

sigmax1 = std(x1); %calculate sigma for each class
sigmax2 = std(x2);

Z1 = z(:,1); %format test data
Z2 = z(:,2);

n = length(z);

classw1 = 0; 
classw2 = 0;

W1 = [];
W2 = [];

for i = 1:n
    
    Px11 = normpdf(Z1(i),meanx1(:,1),sigmax1(:,1)); %Calculate likelyhood for each feature, for each class
    Px12 = normpdf(Z2(i),meanx1(:,2),sigmax1(:,2));
    Px21 = normpdf(Z1(i),meanx2(:,1),sigmax2(:,1));
    Px22 = normpdf(Z2(i),meanx2(:,2),sigmax2(:,2));
    
    probx1 = Px11 * Px12; %Since we assume independence, the total probability is the union between both features
    probx2 = Px21 * Px22;
    
    if(probx1 > probx2)     %Keep track of what each test point was classified as
        classw1 = classw1 + 1;
        
        W1 = [W1;z(i,1) z(i,2)];    %Add points to matrix to graph
    
    elseif(probx1 < probx2)
        classw2 = classw2 +1;
        
        W2 = [W2;z(i,1) z(i,2)];
        
    end
    
end

figure
hold on
plot(x1(:,1),x1(:,2),'.'); %plot
plot(x2(:,1),x2(:,2),'+');
title('Training Data');
hold off

figure
hold on
plot(W1(:,1),W1(:,2),'.'); %plot
plot(W2(:,1),W2(:,2),'+');
title('Testing Data');
hold off

fprintf("Class 1: " + classw1 + " " + "out of 30 classified" + '\n');
fprintf("Class 2: " + classw2 + " " + "out of 30 classified" + '\n');

