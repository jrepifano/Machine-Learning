clear all; clc;
X= mvnrnd([2 7], [1 0; 0 1], 100); %OG data
Y = mvnrnd([5 5], [1 0;0 1], 100);

figure
hold on
plot(X(:,1),X(:,2),'.'); %plot
plot(Y(:,1),Y(:,2),'+');
title('Training Data');
hold off

theta = [0;0;0];

z = vertcat(X,Y);
[rowsZ colsZ] = size(z);
z1 = z(:,1);
z2 = z(:,2);

cost = 1;

alpha = 0.00005;

sum = [0;0;0];

W1 = [];
W2 = [];
count =0;
costs=[];
deltacost = 1;
while abs(deltacost) > 0.001
    cost = 0;
    sum = [0;0;0];
    for i = 1:rowsZ
        
        x = [1;z1(i);z2(i)];
        h = (1/(1+exp(-(theta'*x))));
        
        if(i < 101)
            y = 0;
            cost = cost + (-log(1-h));
            sum = sum + (h-y)*x;
            
        elseif(i >= 101)
            y =1;
            cost = cost + (-log(h));
            sum = sum+ (h-y)*x;
            
        end
    end
    if count > 0
        deltacost = costs(length(costs)) - cost;
    else 
        deltacost = abs(cost);
    end
    theta = theta - alpha * sum;
    count = count+1;
    costs = [costs cost];
end
disp(theta);

countw1 = 0;
countw2 = 0;

for j = 1:length(z)
    
    x = [1;z1(j);z2(j)];
    h = (1/(1+exp(-(theta'*x))));
    
    if (h < 0.5)
        W1 = [W1;z(j,1) z(j,2)];
        countw1 = countw1 + 1;
    elseif( h > 0.5)
        W2 = [W2;z(j,1) z(j,2)];
        countw2 = countw2 + 1;
    end
end

figure
hold on
plot(W1(:,1),W1(:,2),'.'); %plot
plot(W2(:,1),W2(:,2),'+');
title('Testing Data');
hold off


B = mnrfit(X,Y); %test matlab on data
disp(B);
disp(countw1);
disp(countw2);

BW1 = [];
BW2 = [];

for j = 1:length(z)
    
    x = [1;z1(j);z2(j)];
    h = (1/(1+exp(-(B'*x))));
    
    if (h < 0.5)
        BW1 = [BW1;z(j,1) z(j,2)];
        countw1 = countw1 + 1;
    elseif( h > 0.5)
        BW2 = [BW2;z(j,1) z(j,2)];
        countw2 = countw2 + 1;
    end
end


figure
hold on
plot(BW1(:,1),BW1(:,2),'.'); %plot
plot(BW2(:,1),BW2(:,2),'+');
title('MNRfit Testing Data');
hold off
