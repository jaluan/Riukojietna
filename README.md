# Riukojietna
Codes to calculate cosmogenic nuclide production and decay with ice cover and erosion.

Codes to create figures in Stroeven, A. P., Rosqvist, G. C., Koester, A. J., Andersen, J. L., Wahlström, C.-A., and Lifton, N. A.: Riukojietna, a small low-altitude ice cap that may have persisted through the Holocene: Evidence from combining cosmogenic multi-nuclide dating and lacustrine sediment records, EGUsphere [preprint], https://doi.org/10.5194/egusphere-2026-447, 2026.

Steps to create plots of cosmogenic nuclide accumulation in Riukojietna samples.

1. Run compile_production.m

This will prompt you for two input files, first type riuko_CBefin.txt, next type riuko_BeAlfin.txt
The code saves a file (RiukoProduction.mat) that contains two structures - ‘consts’ which contains various parameters for calculating cosmogenic nuclide production and ‘samples’ which contains sample metadata, nuclide concentrations and production parameters for each of the five Riukojietna samples.

2. Run show_CN_and_Ice.m

This will plot the Riukojietna 14C and 10Be data pairwise for sample 1+2 and 3+4. Next it will produce an ice-history vector and calculate the resulting accumulation of cosmogenic nuclides over time (by calling ‘forward_CN_bedrock.m’). 

/Jane Lund Andersen, 09.06.2026
