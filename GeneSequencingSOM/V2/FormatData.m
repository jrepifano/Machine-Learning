clc; clear all;

tic
[Header, Sequence] = fastaread('RDPFull.fasta');
Sequence = regexprep(Sequence,'N','');

x = ParseFasta('RDPFull.fasta');

data = [];
labels = [];

k = 2;

for i = 1:length(Sequence)
    
       labels = [labels; x(i,1)];
       
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

tax1 = scrapeTax(labels,1);
tax2 = scrapeTax(labels,2);



function [fasta_data] = ParseFasta(fasta_filename)

fasta = fastaread(fasta_filename);


fasta_data = cell(length(fasta), 3);
for i = 1:length(fasta)
    header = textscan(fasta(i).Header, '%s');
    seqID = header{1}{1};
    tax = header{1}{2}(6:end-1);
    
    
    fasta_data{i, 1} = tax;
    fasta_data{i, 2} = fasta(i).Sequence;
    fasta_data{i, 3} = seqID;
    
    
end


end