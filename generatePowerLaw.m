function randPowerLaw = generatePowerLaw(alpha, NRand)
%% Generate random numbers from power-law distribution
%%% use inverse cumulative probabity distribution to generate random
%%% numbers from the customized distribution
%%% see 'https://en.wikipedia.org/wiki/Inverse_transform_sampling' for
%%% explaination

randNum = rand(NRand,1);
randPowerLaw = (1-randNum) .^ (1/(-alpha+1));
