clear
clc

%% number of random numbers
numRand = 1000;
%% Uniform distribution [0,bUnif]
bUnif = 5;
randUniform = rand(numRand, 1) * bUnif;

%% Bimodal distribution
%%% weight, mean and standard deviation of two normal distributions
weights = [0.4 0.6];
m = [2.5 4.5];
s = [0.5 0.5];

randBimodal = generateBimodalDistribution(weights, m,s, numRand);

%% Power-law distribution
alpha = 3.0;
randPowerLaw = generatePowerLaw(alpha, numRand);
