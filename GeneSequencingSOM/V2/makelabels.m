clc; clear all;

data = load('labels.mat');
data = data.labels;
labels = [];

for i = 1:length(data)
    temp = scrapeTax(data{i},1);
    switch temp
        case 'Bacteria'
        labels = [labels;1];
        case 'Archaea'
        labels = [labels;2];
    end
    
end