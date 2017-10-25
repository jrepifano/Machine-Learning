clear all;clc;

x = mvnrnd([2 10], [1 1], 100); %OG data
y = mvnrnd([7 3], [1 1], 100);

figure;
hold on
plot(x(:,1),x(:,2),'.'); %plot
plot(y(:,1),y(:,2),'+');
title('Training Data');
hold off

z = vertcat(x,y);
z1 = z(:,1);
z2 = z(:,2);
one = ones(200,1);
Z = cat(2,one,z1,z2);

w0 = 1;
w1 = 1;
w2 = 1;

H = [1 0 0;0 1 0;0 0 1];
W = [w0 w1 w2];
Y = diag([ones(100,1) ;-ones(100,1)]);
b = -ones(200,1);
f = zeros(3,1);
A = -Y*Z;

svm = quadprog(H,[],A,b);

testset = linspace(2,10);
w1 = [];
w2 = [];

for i = 1:length(Z)
   
    result = svm(1) + z1(i)*svm(2) + z2(i)*svm(3);
    
    if(result >= 1)
        
        w1 = [w1;z1(i) z2(i)];
        
    elseif(result <= -1)
        
        w2 = [w2;z1(i) z2(i)]; 
        
    end  
    
end

bordertest = mvnrnd([5 6], [2 2], 100000);
bordertest1 = bordertest(:,1);
bordertest2 = bordertest(:,2);
border = [];
for j = 1:length(bordertest)
    
    result = svm(1) + bordertest1(j)*svm(2) + bordertest2(j)*svm(3);
    
    if(result < 0.005 && result > -0.005)
       
        border = [border;bordertest1(j) bordertest2(j)];
        
    end
end


figure;
hold on
plot(w1(:,1),w1(:,2),'.'); %plot
plot(w2(:,1),w2(:,2),'+');
plot(border(:,1),border(:,2),'o');
title('Testing Data with Decision Boundary');
hold off
