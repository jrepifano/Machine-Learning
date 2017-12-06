clc; clear all;

FASTAfilename = 'dog.fa';
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