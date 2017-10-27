clear all; clc;
X = mvnrnd([2 5], [1 1], 100); %OG data
Y = mvnrnd([4 3], [1 1], 100);

Z = vertcat(X,Y);

x = [1 10];
y = [10 1];
mus = [];
H = 50;
j = 0;
while(H > 1)
classx = [];
classy = [];
for i = 1:length(Z)
   distx = pdist2(x,Z(i,1:2));
   disty = pdist2(y,Z(i,1:2));
   if(distx < disty)
      classx = [classx;(Z(i,1:2))];
   else
      classy = [classy;(Z(i,1:2))];
   end
end
mus = [mus;x];
x = mean(classx);
y = mean(classy);
H = H -1;
end


figure
hold on
plot(X(:,1),X(:,2),'.'); %plot
plot(Y(:,1),Y(:,2),'+');
title('Training Data');
plot(x(:,1),x(:,2),'x','linewidth',8); %plot
plot(y(:,1),y(:,2),'x','linewidth',8);

hold off
