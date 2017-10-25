mu = [-1.5 1.5];
mu2 = [-1 1];
sigma = [1 0.4;0.4 0.7];


data = mvnrnd(mu,sigma,1000);
data2 = mvnrnd(mu,sigma,1000);
figure
hold on;
plot(data(:,1),data2(:,1),'r.');
plot(data(:,2),data2(:,2),'b.');
hold off;