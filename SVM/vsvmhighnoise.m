clc; clear all;

x = mvnrnd([4 5], [5 5], 100); %OG data
y = mvnrnd([7 3], [5 5], 100);

figure;
hold on
plot(x(:,1),x(:,2),'.'); %plot
plot(y(:,1),y(:,2),'+');
title('Training Data');
hold off

z = vertcat(x,y);
Y = [ones(100,1);-ones(100,1)];


vsvmmodel = fitcsvm(z,Y,'Standardize',true,'KernelFunction','RBF','KernelScale','auto');

prediction = predict(vsvmmodel,z);
c1 = [];
c2 = [];
for i = 1:length(z)
    if(prediction(i) > 0)
        c1 = [c1;z(i,1) z(i,2)];
    else
        c2 = [c2;z(i,1) z(i,2)];
    end
end

figure;
hold on
plot(c1(:,1),c1(:,2),'.'); %plot
plot(c2(:,1),c2(:,2),'+');
title('Testing with VSVM, RBF Kernel');
hold off

CVSVMModel = crossval(vsvmmodel);
classLoss = kfoldLoss(CVSVMModel);
fprintf("K-fold loss: " + classLoss);




