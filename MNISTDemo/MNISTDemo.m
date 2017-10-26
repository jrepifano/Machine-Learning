clc; clear all;
tic;
images = loadMNISTImages('train-images.idx3-ubyte');
labels = loadMNISTLabels('train-labels.idx1-ubyte');

testimages = loadMNISTImages('t10k-images.idx3-ubyte');
testlabels = loadMNISTLabels('t10k-labels.idx1-ubyte');

for i = 1:784
    if(images(i,1) == 0)
        images(i,1) = 0.0000001;
    end
end

for i = 1:784
    if(testimages(i,1) == 0)
        testimages(i,1) = 0.0000001;
    end
end

labels = convertlabels(labels);
testlabels = converttestlabels(testlabels);





mlp = feedforwardnet([200 200 200]);
net = train(mlp,images,labels','useGPU','yes','showResources','yes');
%view(net)
y = net(testimages);
perf = perform(net,testlabels',y);
plotconfusion(testlabels', y, 'Classifications and Missclassifications');

elapsedtime = toc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function x = convertlabels(labels)
flabels = zeros(60000,10);
for i = 1:length(labels)
   y = labels(i)+1;
   flabels(i,y) = flabels(i,y)+1;
end
x = flabels;
end

function x = converttestlabels(labels)
flabels = zeros(10000,10);
for i = 1:length(labels)
   y = labels(i)+1;
   flabels(i,y) = flabels(i,y)+1;
end
x = flabels;
end


function images = loadMNISTImages(filename)
%loadMNISTImages returns a 28x28x[number of MNIST images] matrix containing
%the raw MNIST images

fp = fopen(filename, 'rb');
assert(fp ~= -1, ['Could not open ', filename, '']);

magic = fread(fp, 1, 'int32', 0, 'ieee-be');
assert(magic == 2051, ['Bad magic number in ', filename, '']);

numImages = fread(fp, 1, 'int32', 0, 'ieee-be');
numRows = fread(fp, 1, 'int32', 0, 'ieee-be');
numCols = fread(fp, 1, 'int32', 0, 'ieee-be');

images = fread(fp, inf, 'unsigned char');
images = reshape(images, numCols, numRows, numImages);
images = permute(images,[2 1 3]);

fclose(fp);

% Reshape to #pixels x #examples
images = reshape(images, size(images, 1) * size(images, 2), size(images, 3));
% Convert to double and rescale to [0,1]
images = double(images) / 255;

end

function labels = loadMNISTLabels(filename)
%loadMNISTLabels returns a [number of MNIST images]x1 matrix containing
%the labels for the MNIST images

fp = fopen(filename, 'rb');
assert(fp ~= -1, ['Could not open ', filename, '']);

magic = fread(fp, 1, 'int32', 0, 'ieee-be');
assert(magic == 2049, ['Bad magic number in ', filename, '']);

numLabels = fread(fp, 1, 'int32', 0, 'ieee-be');

labels = fread(fp, inf, 'unsigned char');

assert(size(labels,1) == numLabels, 'Mismatch in label count');

fclose(fp);

end

