clc; clear all;

tic
[Header, Sequence] = fastaread('RDPFull.fasta');

data = [];


for i = 1:length(Sequence)
   temp = char(Sequence(i));
   Nmers = nmercount(temp,3);
   mat = cell2mat(Nmers(:,2));
   data = horzcat(data,mat);
    
end
toc