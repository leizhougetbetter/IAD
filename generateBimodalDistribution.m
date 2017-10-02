function randBimodal = generateBimodalDistribution(weights, m,s, NRand)
%% Construct two scaled and translated gaussians
%%%% transform the standard norm distribution into the new ones with mean m and
%%%% std s
numRandNormal = NRand^2;
X = randn(numRandNormal,length(weights)) .* repmat(s,numRandNormal,1) + repmat(m,numRandNormal,1);

%% Selection of one gaussian or the other according to the weights

%%%% select random numbers from eath gaussian distribution based on the weights q

%%% generate nb [0,1] uniformly distributed random numbers
rsel = rand(numRandNormal,1);
%%%% repmat(rsel,1,length(q)) -> replicate the sequences of random numbers to nb * 2 matrix with eath column being the random number sequences

%%% select the random number which is larger than the first weight q(1) and store it in the first column of idx1, the second column all equals ZERO.
idx1 = (repmat(rsel,1,length(weights)) > repmat(cumsum(weights),numRandNormal,1));
%%% select the random number which is less than the first weight q(1) and store it in the first column of idx1, the second column all equals ONE.
idx2 = (repmat(rsel,1,length(weights)) < repmat(cumsum(weights),numRandNormal,1));
%%% select the random numbers larger than q(1) but less than 1.0 and store them in the second column.
idx1(:,2:end) = idx1(:,1:end-1) .* idx2(:,2:end);
%%% select the random numbers less than q(1) and store them in the first column; 
idx1(:,1) = idx2(:,1);
%%% X.*idx1 is a nb*2 matrix, in each row only one element is non-zero which corresponds to the random number select from the first or second distribution.
X = sum(X.*idx1,2);
% 
%% Plot
[y,x]=ksdensity(X);
totalY = sum(y);
yRescale = y/totalY;

% figure;plot(x,yRescale,'linewidth',2)
% title('\mu_1 = 2.5, \mu_2 = 4.5, \sigma_1 = 0.5, \sigma_2 = 0.5, w_1 = 0.4, w_2 = 0.6')
%% Generate random numbers from Bimodal distribution
%%% use inverse cumulative probabity distribution to generate random
%%% numbers from the customized distribution
%%% see 'https://en.wikipedia.org/wiki/Inverse_transform_sampling' for
%%% explaination

probRand = rand(NRand,1);
randBimodal = ksdensity(X, probRand, 'function','icdf');

% hist(randBimodal,100)

