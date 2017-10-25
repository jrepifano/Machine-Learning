clear all;clc;

w1 = mvnrnd(2, 1, 100); %OG data
w2 = mvnrnd(7, 1, 100);

x1 = w1(1:35); %training data = 70% of d1
x2 = w2(1:35);

z1 = w1(86:100); %testing data = 30% of d1
z2 = w2(86:100);

z = vertcat(z1,z2); %concatenate testing data into 1 matrix

d = length(x1);
mean1 = sum(x1(:))/length(x1); %mean calculation
mean2 = sum(x2(:))/length(x2); 

meanz1 = sum(z1(:))/length(z1); %mean calculation
meanz2 = sum(z2(:))/length(z2); 

hold on
histogram(w1); %plot hist
histogram(w2);
hold off

sum1 = 0;
sum2 = 0;

for i = 1:d
   sum1 = sum1 + (x1(i)-mean1)^2;
   sum2 = sum2 + (x2(i)-mean2)^2;
end
covariance1 = sum1/length(x1);  %covariance 
covariance2 = sum2/length(x2);

n = length(z);


postx1 = 0;
postx2 = 0;

    for j = 1:n
        
        
       likelyw1 = ((2 * pi * (covariance1^2))^-0.5) * exp(-0.5 * (((z(j)- mean1)^2)/(covariance1^2))); %compute likelyhood
       likelyw2 = ((2 * pi * (covariance2^2))^-0.5) * exp(-0.5 * (((z(j)- mean2)^2)/(covariance2^2)));
       
       
       if likelyw1 > likelyw2
           postx1 = postx1 +1;
       
       elseif(likelyw1 < likelyw2)
           postx2 = postx2 +1;
       end

    end
    
    disp(postx1); %total number of datapoints classified to be in w1
    disp(postx2); %total number of datapoints classified to be in w2
    