clc; clear all;

tic
[Header, Sequence] = fastaread('RDPFull.fasta');
Sequence = regexprep(Sequence,'N','');

data = [];

k = 8;

for i = 1:length(Sequence)
    
       temp = char(Sequence(i));
       Nmers = nmercount(temp,k);
       mat = cell2mat(Nmers(:,2));
       if(length(mat) < 4^k)
            x = 4^k-length(mat);
            x = zeros(x,1);
            mat = [mat;x];
       end
       data = [data mat];
    
end
toc