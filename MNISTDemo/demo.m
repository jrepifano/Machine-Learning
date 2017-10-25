clc;clear all;

net = load('net300.mat');
net = getfield(net,'net');

testimage = imread('testimage9.png');
testimage = rgb2gray(testimage);
testimage = uint8(255)-testimage;
testimage = imbinarize(testimage);
testimage = padarray(testimage,[4 4],0,'both');
imshow(testimage);

testimage = reshape(testimage,[784,1]);

y = net(testimage);
z = max(y);

for i = 1:length(y)
    if(y(i) == z)
        x = i-1;
        fprintf("The number you drew was: " + x + "\n");   
    end
end