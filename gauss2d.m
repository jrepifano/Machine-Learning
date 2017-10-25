function p=gauss2d(X,Y, MU, SIGMA) %also see mvnrnd() to directly generate Gaussian data
I=length(X);J=length(Y);
%MU=[-1 1]; SIGMA = [.9 .4; .4 .3];
for i=1:I
for j=1:J
p(i,j) = mvnpdf([X(i) Y(j)],MU,SIGMA);
end
end
subplot(221)
mesh(X,Y,p); title('The theoretical distribution of 2?D Gaussian')
RND = mvnrnd(MU,SIGMA,10000); %RND: Random, normally distributed multivariate data
subplot(222); plot(RND(:,1),RND(:,2),'r.')
title('10000 data points randomly drawn from 2D Gaussian')
subplot(223)
hist3(RND, [30 30]); %This one plots the histogram on a 30x30 bin array
histogram=hist3(RND, [30 30]); %This returns the histogram data, but does not plot
title('3?D Histogram of the 2?D data')
histogram1 = histogram'; histogram1( size(histogram,1) + 1 ,size(histogram,2) + 1 ) = 0;
% Generate grid for 2?D projected view of intensities
xb = linspace(min(RND(:,1)),max(RND(:,1)),size(histogram,1)+1);
yb = linspace(min(RND(:,2)),max(RND(:,2)),size(histogram,1)+1);
% Make a pseudocolor plot on this grid
subplot(224); handle = pcolor(xb,yb,histogram1);
title('Pseudocolor plot of the 3?D histogram of the 2?D Guassian random data');