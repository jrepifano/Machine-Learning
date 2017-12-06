clc; clear all;

[Header, Sequence] = fastaread('RDPFull.fasta');

data = [];
for i = 1:length(Sequence)
   temp = char(Sequence(i));
   Nmers = nmercount(temp,8);
   data = [data;Nmers(:,2)];
    
end