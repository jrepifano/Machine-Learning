clc; clear all;

FASTAfilename = 'mouse.fa';
fileInfo = dir(which(FASTAfilename))

fidIn = fopen(FASTAfilename,'r');
header = fgetl(fidIn)

[fullPath, filename, extension] = fileparts(FASTAfilename);
mmFilename = [filename '.mm']
fidOut = fopen(mmFilename,'w');

newLine = sprintf('\n');
blockSize = 2^20;
while ~feof(fidIn)
    % Read in the data
    charData = fread(fidIn,blockSize,'*char')';
    % Remove new lines
    charData = strrep(charData,newLine,'');
    % Convert to integers
    intData = nt2int(charData);
    % Write to the new file
    fwrite(fidOut,intData,'uint8');
end

fclose(fidIn);
fclose(fidOut);

mmfileInfo = dir(mmFilename)

chr1 = memmapfile(mmFilename, 'format', 'uint8')

numNT = numel(chr1.Data);
blockSize = 500000;
numBlocks = floor(numNT/blockSize);

ratio = zeros(numBlocks+1,1);

A = nt2int('A'); C = nt2int('C'); G = nt2int('G'); T = nt2int('T');

for count = 1:numBlocks
    % calculate the indices for the block
    start = 1 + blockSize*(count-1);
    stop = blockSize*count;
    % extract the block
    block = chr1.Data(start:stop);
    % find the GC and AT content
    gc = (sum(block == G | block == C));
    at = (sum(block == A | block == T));
    % calculate the ratio of GC to the total known nucleotides
    ratio(count) = gc/(gc+at);
end

block = chr1.Data(stop+1:end);
gc = (sum(block == G | block == C));
at = (sum(block == A | block == T));
ratio(end) = gc/(gc+at);

indices = find(ratio>0.5);
ranges = [(1 + blockSize*(indices-1)), blockSize*indices];
fprintf('Region %d:%d has GC content %f\n',[ranges ,ratio(indices)]')