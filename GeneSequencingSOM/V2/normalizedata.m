clc; clear all;

k = 2;

data = load(['k'...
    num2str(k) '.mat']);
data = data.data;
       
rowsum = sum(data,2);

[m,n] = size(data);

normalizedData = zeros(m,n);

for i = 1:m
   
    for j = 1:n
        
        normalizedData(i,j) = data(i,j)/rowsum(i);
        
    end
    
end