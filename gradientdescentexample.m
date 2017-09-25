n = 100;
noise = rand(n,1);
x = rand(n,1).*10;
y = 5 + 6*x + noise;
plot(x,y,'.');
%x = [ones(size(x)) x];
%theta = regress(y,x);
%disp(theta);


theta = [0;0];
alpha = 0.00005;
cost = 1;
sum = [0;0];

gradientdescent(theta,alpha,cost,x,y,sum)

function gradientdescent(theta,alpha,cost,x,y,sum)

while abs(cost) > 0.0005

    cost = 0;
    sum = [0;0];
    
    for i = 1:length(x)

        X = [1;x(i)];
        h = theta'*X;
        
        sum = sum + (h-y(i)) * X;
        cost = (h-y(i)); 
        

    end
theta = theta - alpha * sum;

%disp(theta);
%disp(cost);
end
disp(theta);
b = theta(1);
m = theta(2);
z = m*x + b;
plot(x,y,'.');hold on;
plot(x,z,'-');
end


