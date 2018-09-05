## Introduction

This software performs the simulations for the paper: **Individualized aspiration dynamics: Calculation by proofs**, by *Bin Wu* and *Lei Zhou*.

## Included files

#### Monte Carlo simulations (see the code in each folders)
- *Control.f90*: The main program of the Monte Carlo simulation used in the paper. It defines all the global variables and reads all the input parameters except the static network strucutre. 

- *frequencyCalculation.f90*: Caculate the distribution of strategy A when the system reaches its stationary states.

- *Inintial_strategies_not_equal.f90*: Initialize individuals' strategies according to a specified frequency of strategy A.

- *readNetwork.f90*: Read the static network structure.

- *PGG_OnlyFocalNode_AnyGraph_New.f90*: Calculate the payoff of the individual who is randomly selected to update its strategy.

- *AspirationUpdate.f90*: The randomly selected individual compares its aspiration with its payoff and updates its strategy based on the aspiration updating.

- *MT_PNRG.f90*: A module containes the random number generators from the IMSL library. 

- *AspirationDynamicsParameters.txt*: The parameter file contains the group size, payoff matrix, personal aspiration values and selection intensity.

- *yParameters.inp*: Another parameter file contains the type of the network (random, regular, or scale-free), the starting point, increment, and ending point of the payoff entry $a_0$, number of repetitions in the whole simulation, and the initial frequency of strategy A.

- *NetworkStructure_AspDyn_RG*: Network structure of the random graph with size 100. Each node corresponds to 2 rows. For example, the No. $i$ node corresponds to Row $2i-1$ and $2i$: Row $2i-1$ defines its degree; Row $2i$ defines the index of all its neighbors. 

- *NetworkStructure_AspDyn_RRG*: Network structure of the random regular graph with size 100. 

- *NetworkStructure_AspDyn_SF*: Network structure of the scale-free network with size 100.

#### Aspiration generating
- *generateAspirationValues.m*: Matlab code for generating aspiration values following uniform, bimodal or power-law distributions.

- *generateBimodalDistribution.m*: The Function for creating bimodal distribution via mixture of two nomral distributions and generating random numbers following this distriubtion using [inverse transform sampling method](https://en.wikipedia.org/wiki/Inverse_transform_sampling).

- *generatePowerLaw.m*: The function for generating random numbers following this power-law distribution using inverse transform sampling method.

#### Average abundance plot
- *avgAbundance_a_0.m*: Matlab code for plotting the average abundance of strategy A as a function of the payoff entry $a_0$ for a single model setting.

- *averageAbundanceA_beta.m*: Matlab code for plotting the average abundance of strategy A as a function of the selection intensity $\beta$ for two sets of aspirations.

Please see the **Examples** folder to replicate the upper-left panels of Figure 1 and average abundance of strategy A with power-law distributed aspirations on scale-free networks in Figure 3. 

#### Others
- *LICENSE*: MIT License

- *README.MD*: This file 


## Dependencies

Fortran 90 files for **Monte Carlo simulations** was tested using *Intel(R) Visual Fortran* version 13.0.3600.2010 and IMSL Fortran Numerical Library version 6.0. To use the random number generator, the IMSL static library is needed, in particular the dynamical library *libiomp5md.lib*. 

Matlab files for **Aspiration generating** and **Average abundance plot** was created with *Matlab 2016b*.


## Running the software

All the files of **Monte Carlo simulations** should be put in the same folder. For convenience, all the code needed for Figure 1&3 and Figure 2 are already seperated in different folders. In addition, this README file apples to both cases. 

The default parameter setting is for population size 100 with group size 3 on the regular graph. To change the network type to random graph or scale-free network, change the first setence *networkType = RRG* to  *networkType = RG* or *networkType = SF* in the **OtherParameters.inp** file.

The program for Figure 1&3 generates a series of output files named *numA_Strategy_Dist*. In this file, each row corresponds to a distriubtion of the number of strategy A recorded in the simulation. Varying the value of $\beta$ and then use **avgAbundance_beta.m** to plot the average abundance of strategy A as a function as the selection intensity $\beta$ for a single model setting.

The program for Figure 2 will output *numA_Strategy_Dist_repeat_X* (X is the index of repetition). In these files, the distriubtion of the number of strategy A is recorded. Varying the value of $a_0$ and then use **avgAbundance_a_0.m** to plot the average abundance of strategy A as a function as the payoff entry $a_0$ for a single model setting.

## License

See LICENSE for details. 
