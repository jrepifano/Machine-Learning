%Gaussian Mixture Model
clear all; clc;
X = mvnrnd([2 5], [1 1], 100); %OG data
Y = mvnrnd([4 3], [1 1], 100);

Z = vertcat(X,Y);
Z1 = Z(:,1);
Z2 = Z(:,2);


mux = [0 0];
muy = [8 8];
stdx = [1 1];
stdy = [1 1];


H = 10;

hold on
plot(Z(:,1),Z(:,2),'.'); %plot
title('GMM');
plot(mux(:,1),mux(:,2),'x','linewidth',8); %plot
plot(muy(:,1),muy(:,2),'x','linewidth',8);
axis([0 8 0 8]);
hold off

while(H > 1)
classx = [];
classy = [];
for i = 1:length(Z)
    
    Px11 = normpdf(Z1(i),mux(:,1),stdx(:,1)); %Calculate likelyhood for each feature, for each class
    Px12 = normpdf(Z2(i),mux(:,2),stdx(:,2));
    Px21 = normpdf(Z1(i),muy(:,1),stdy(:,1));
    Px22 = normpdf(Z2(i),muy(:,2),stdy(:,2));
    
    probx1 = Px11 * Px12; %Since we assume independence, the total probability is the union between both features
    probx2 = Px21 * Px22;
    
    if(probx1 > probx2)     %Keep track of what each test point was classified as

        classx = [classx;Z(i,1) Z(i,2)];    %Add points to matrix to graph
    
    elseif(probx1 < probx2)

        classy = [classy;Z(i,1) Z(i,2)];
        
    end
    

    
end

mux = mean(classx);
muy = mean(classy);
stdx = std(classx);
stdy = std(classy);
H = H -1 ;

end

figure
hold on
plot(X(:,1),X(:,2),'.'); %plot
plot(Y(:,1),Y(:,2),'+');

title('GMM Clustering');

plot(mux(:,1),mux(:,2),'x','linewidth',8); %plot

plot(muy(:,1),muy(:,2),'x','linewidth',8);

circle2(mux(1),mux(2),stdx(1)*.5,stdx(2)*.5);
circle2(muy(1),muy(2),stdy(1)*.5,stdy(2)*.5);

circle2(mux(1),mux(2),stdx(1),stdx(2));
circle2(muy(1),muy(2),stdy(1),stdy(2));

circle2(mux(1),mux(2),stdx(1)*2,stdx(2)*2);
circle2(muy(1),muy(2),stdy(1)*2,stdy(2)*2);

axis([0 8 0 8]);
hold off

function h = circle2(x,y,rx,ry)
dx = rx*2;
dy = ry*2;
px = x-rx;
py = y-ry;
h = rectangle('Position',[px py dx dy],'Curvature',[1,1]);
end
