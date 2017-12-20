clc; clear all;

k = 8;

data = load(['k'...
    num2str(k) '.mat']);
data = data.data;
       
rowsum = sum(data,1);

[m,n] = size(data);

normalizedData = zeros(m,n);

for i = 1:n
   
    for j = 1:m
        
        normalizedData(j,i) = data(j,i)/rowsum(i);
        
    end
    
end