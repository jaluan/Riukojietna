# Riukojietna
Codes to calculate cosmogenic nuclide production and decay with ice cover and erosion.

Codes to create figures in Stroeven et al., (in prep) ...

Steps to create plots of cosmogenic nuclide accumulation in Riukojietna samples.

1. Run compile_production.m

This will prompt you for two input files, first type riuko_CBefin.txt, next type riuko_BeAlfin.txt
The code saves a file (RiukoProduction.mat) that contains two structures - ‘consts’ which contains various parameters for calculating cosmogenic nuclide production and ‘samples’ which contains sample metadata, nuclide concentrations and production parameters for each of the five Riukojietna samples.

2. Run show_CN_and_Ice.m

This will plot the Riukojietna 14C and 10Be data pairwise for sample 1+2 and 3+4. Next it will produce an ice-history vector and calculate the resulting accumulation of cosmogenic nuclides over time (by calling ‘forward_CN_bedrock.m’). For this part I have implemented three methods (switch by setting ‘method’ = 1, 2, or 3).

Method 1: loading pre-defined ice-histories by calling ‘define_ice_history.m’ with an input parameter to switch between three different scenarios (more can easily be added).

Method 2: Hard-coding an ice-history directly into the script

Method 3: Looping over a variable to plot cosmogenic nuclide accumulation histories for a range of ice histories at once. The variable that is looped can easily be changed.

/Jane Lund Andersen, 21.11.2023
