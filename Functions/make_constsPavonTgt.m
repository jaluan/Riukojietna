function out = make_constsPavonTgt()

% This function creates and saves a structure with relevant constants and
% external data for the C and Be exposure age and erosion rate calculators.  
%
% Syntax: make_conts_2
% (no arguments)
%
% See the text documentation or the code itself for what the constants
% actually are. 
%
%
% This update adds production rates for various scaling factors. It also
% packages precalculated paleomagnetic data into the constants structure.
%
% Written by Greg Balco -- Berkeley
% Geochronology Center
% balcs@u.washington.edu -- balcs@bgc.org
% 
% Modified by Brent Goehring -- Lamont-Doherty Earth Observatory
% goehring@ldeo.columbia.edu
% and Nat Lifton -- Purdue University
% nlifton@purdue.edu

% April, 2011
% 
% Part of the CRONUS-Earth online calculators: 
%      http://hess.ess.washington.edu/math
%
% Copyright 2011, University of Washington, Columbia University and the
% Purdue University
% All rights reserved
% Developed in part with funding from the National Science Foundation.
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License, version 2,
% as published by the Free Software Foundation (www.fsf.org).

consts.version = '3.2p'; %Added Balco (2017) updated muon constants 8/8/17 NL
consts.prepdate = fix(clock);

% Be-10 decay constant -- value compatible with Nishiizumi standards
% See Nishiizumi (2007) for details.

consts.l10 = 4.998e-7; %per Balco 2010 (online publication) update of 
                        %constants file from 2.2 to 2.2.1

% Note that the uncertainty is not used in exposure-age or erosion-rate
% calculators. Here only for development purposes.

consts.dell10 = 0.043e-7; %per Balco 2010 (online publication) update of 
                        %constants file from 2.2 to 2.2.1

% C-14 decay constant 

% consts.l14 = log(2)/5730;
consts.l14 = log(2)/5700;

% Note that the uncertainty is not used in exposure-age or erosion-rate
% calculators. Here only for development purposes. 

consts.dell14 = log(2) * 40/(5700^2);

% Al-26 decay constant -- value compatible with Nishiizumi standards
% lambda = 9.83e-7 --> t(1/2) = 0.705e6 yr
% See Nishiizumi (2004) for details.

consts.l26 = 9.83e-7;

% Note that the uncertainty is not used in exposure-age or erosion-rate
% calculators. Here only for development purposes. 

consts.dell26 = 2.5e-8;
% Effective attenuation length for spallation in rock
% Commonly accepted value: 160 g/cm2
% For discussion see Gosse and Phillips (2000)

consts.Lsp = 160;

% Fsp - fraction of total production by spallation rather than muons
% For use with Lal/Stone scaling scheme in exposure age calculation
% For details, see Stone (2000)
% This aspect of Stone(2000) is de-emphasized in version 2. These constants
% are only in use for historical comparisons and quick initial guesses for 
% the exposure age and erosion rate solvers. 

consts.Fsp3 = 1.000;
consts.Fsp10 = 0.978;
consts.Fsp14 = 0.8296;
consts.Fsp26 = 0.974;


% Be-10 standardization info.

% Standards comparison/conversion lookup table - from Balco CRONUS
% Calculator documentation - Feb 15, 2011

consts.be_stds_names = strvcat('07KNSTD','KNSTD','NIST_Certified','LLNL31000','LLNL10000',...
    'LLNL3000','LLNL1000','LLNL300','NIST_30000','NIST_30200','NIST_30300','NIST_30600','NIST_27900',...
    'S555','S2007','BEST433','BEST433N','S555N','S2007N');
consts.be_stds_cfs = [1.0000 0.9042 1.0425 0.8761 0.9042 0.8644 0.9313 0.8562 0.9313 0.9251 0.9221 0.9130 ...
    1.000 0.9124 0.9124 0.9124 1.000 1.000 1.000]';


% Same for Al-26. A zero placeholder is
% also allowed. - from Balco CRONUS
% Calculator documentation - Feb 15, 2011

consts.al_stds_names = strvcat('KNSTD','ZAL94','AL09','ZAL94N','SMAL11','Z92-0222','0');
consts.al_stds_cfs = [1.0000 0.9134 0.9134 1.0000 1.021 1.000 1.000]';

% Reference production rates at SLHL for spallation according to various
% scaling schemes. Letter codes De, Du, Li, and St refer to
% scaling schemes of Desilets et al. (2006), Dunai (2001), Lifton (2006),
% and Stone (2000) respectively. The final letter code Lm refers to the
% paleomagnetically corrected version of the Lal 1991/Stone 2000 scaling
% factors.
%
%

% CRONUS Primary Results from Borchers et al. (2016) and Phillips et al. (2016)
% Note that correct SPhi values per Eq. 3 of Lifton et al. (2014) are not included in Borchers
% et al. (2016) or Marrero et al. (2016) CRONUScalc code, but global means of CRONUS primary 
% site production rates (calculated individially by Lifton, 2/2016) differ only in 2nd 
% decimal place from calculation using same method (individual site PRs, then global mean)
% but with incorrect SPhi values. Uncertainties from Phillips et al. (2016)

consts.P10_ref_LS = 3.92; %nuclide-specific LSD
consts.delP10_ref_LS = 0.31; %nuclide-specific LSD
consts.P10_ref_Lm = 4.00; 
consts.delP10_ref_Lm = 0.32;
consts.P10_ref_St = 4.01;
consts.delP10_ref_St = 0.33;

% consts.P10_ref_LS = 4.09; %flux only
% consts.delP10_ref_LS = 0.35; %flux only

% CRONUS Primary Results from Borchers et al. (2016) and Phillips et al. (2016)
% Note that correct SPhi values per Eq. 3 of Lifton et al. (2014) are not included in Borchers
% et al. (2016) or Marrero et al. (2016) CRONUScalc code, but global means of CRONUS primary 
% site production rates (calculated individially by Lifton, 2/2016) differ only in 2nd 
% decimal place from calculation using same method (individual site PRs, then global mean) 
% but with incorrect SPhi values. Uncertainties from Phillips et al. (2016)

consts.P26_ref_LS = 28.5;  %nuclide-specific LSD
consts.delP26_ref_LS = 3.1;  %nuclide-specific LSD
consts.P26_ref_Lm = 27.9;
consts.delP26_ref_Lm = 2.7;
consts.P26_ref_St = 27.9;
consts.delP26_ref_St = 2.8;

% consts.P26_ref_LS = 28.6; %flux only
% consts.delP26_ref_LS = 3.3; %flux only
% 
% % 26Al production rates assuming canonical 26Al/10Be production ratio of 6.75
% 
% consts.P26_ref_St = consts.P10_ref_St*6.75;
% consts.delP26_ref_St = consts.delP10_ref_St*6.75;
% consts.P26_ref_Lm = consts.P10_ref_Lm*6.75;
% consts.delP26_ref_Lm = consts.delP10_ref_Lm*6.75;
% consts.P26_ref_LS = consts.P10_ref_LS*6.75;
% consts.delP26_ref_LS = consts.delP10_ref_LS*6.75;

% CRONUS Primary Results from Borchers et al. (2016) and Phillips et al. (2016)
% Note that correct SPhi values per Eq. 3 of Lifton et al. (2014) are not included in Borchers
% et al. (2016) or Marrero et al. (2016) CRONUScalc code, but global means of CRONUS primary 
% site production rates (calculated individially by Lifton, 2/2016) differ only in 2nd 
% decimal place from calculation using same method (individual site PRs, then global mean) 
% but with incorrect SPhi values. Recalculated using Hippe and Lifton
% (2014)  - Sample means calculated first, then site production rates.
% Values are averages of all site PRs and standard deviations - 8/16.

% % Baffin Saturated
% consts.P14_ref_LS = 14.5;  %nuclide-specific LSD
% consts.delP14_ref_LS = 0.3; %nuclide-specific LSD
% consts.P14_ref_Lm = 15.2; 
% consts.delP14_ref_Lm = 0.3;
% consts.P14_ref_St = 15.1;  
% consts.delP14_ref_St = 0.3;

consts.P14_ref_LS = 13.0;  %nuclide-specific LSD
consts.delP14_ref_LS = 0.5; %nuclide-specific LSD
consts.P14_ref_Lm = 12.8; 
consts.delP14_ref_Lm = 0.6;
consts.P14_ref_St = 12.9;  
consts.delP14_ref_St = 0.6;

% CRONUS Primary Results from Borchers et al. (2016) and Phillips et al. (2016)
% Note that correct SPhi values per Eq. 3 of Lifton et al. (2014) are not included in Borchers
% et al. (2016) or Marrero et al. (2016) CRONUScalc code, but global means of CRONUS primary 
% site production rates (calculated individially by Lifton, 2/2016) differ only in 2nd 
% decimal place from calculation using same method (individual site PRs, then global mean) 
% but with incorrect SPhi values. Uncertainties from Phillips et al. (2016)

consts.P3_ref_LS = 115;  %nuclide-specific LSD
consts.delP3_ref_LS = 19; %nuclide-specific LSD
consts.P3_ref_Lm = 117; 
consts.delP3_ref_Lm = 13;
consts.P3_ref_St = 118;  
consts.delP3_ref_St = 18;

% % % % NEW ALL POST NENA CALIBRATION - Fenton et al. omitted 
% % % - Fit site by site then averaged - SHAKUN et al. Nature Comm 8/15
% % % Includes whole-sky Rc (De, Li and LS only - Lm and Du don't have it)
% % % Du not valid - not updated and reparameterized by I and H
% % % Uses LSD geomag framework and ERA-40
% % % 
% % consts.P10_ref_St = 4.00;
% % consts.delP10_ref_St = 0.14;
% % consts.P10_ref_Lm = 3.99; 
% % consts.delP10_ref_Lm = 0.14;
% % consts.P10_ref_De = 4.12;
% % consts.delP10_ref_De = 0.27;
% % consts.P10_ref_Du = 4.08;
% % consts.delP10_ref_Du = 0.38;
% % consts.P10_ref_Li = 4.45;
% % consts.delP10_ref_Li = 0.21;
% % consts.P10_ref_LS = 3.98;
% % consts.delP10_ref_LS = 0.12;
% 
% % % NEW ALL POST NENA CALIBRATION - Fenton et al. omitted 
% % - Fit site by site then averaged - SHAKUN et al Peru only. Slightly 
% % different from values above - from "10BePR 2014.xlsx"
% % NO whole-sky Rc (De, Li and LS only - Lm and Du don't have it)
% % Du not valid - not updaetd and reparameterized by I and H
% % Uses Time-dep dipolar Pavon geomag framework and ERA-40 
% % 
% consts.P10_ref_St = 4.00;
% consts.delP10_ref_St = 0.14;
% consts.P10_ref_Lm = 4.03; %Updated 1/7/2016 per Lifton 2016 EPSL calculations
% consts.delP10_ref_Lm = 0.13;
% % consts.P10_ref_De = 4.12;
% % consts.delP10_ref_De = 0.26;
% % consts.P10_ref_Du = 4.08;
% % consts.delP10_ref_Du = 0.36;
% % consts.P10_ref_Li = 4.45;
% % consts.delP10_ref_Li = 0.21;
% consts.P10_ref_LS = 3.99; %Updated 1/7/2016 per Lifton 2016 EPSL calculations
% consts.delP10_ref_LS = 0.17;
% 
% % % NEW CRONUS - 1 MeV Min Neutron E, Sato Muons, ERA40, No NEUS, Sample
% % % Means + CRONUS-A/N Scatter per Borchers
% % % Fit as 1 group per B. Borchers - not site-by-site
% % 
% % consts.P10_ref_St = 4.069;
% % consts.delP10_ref_St = 0.380;
% % consts.P10_ref_Lm = 4.068; 
% % consts.delP10_ref_Lm = 0.380;
% % consts.P10_ref_De = 3.870;
% % consts.delP10_ref_De = 0.365;
% % consts.P10_ref_Du = 3.881;
% % consts.delP10_ref_Du = 0.366;
% % consts.P10_ref_Li = 4.221;
% % consts.delP10_ref_Li = 0.397;
% % consts.P10_ref_LS = 4.000;
% % consts.delP10_ref_LS = 0.380;
% 
% % Huancane only - Kelly et al. 2014 - nuclide-specific
% % consts.P10_ref_LS = 4.000;
% % consts.delP10_ref_LS = 0.092;
% 
% 
% % consts.P10_ref_SX = 4.1627; Borchers P
% % consts.delP10_ref_SX = 0.380;
% 
% 
% % CRONUS Samples Only (PPT/Scotland) - Bailey Dugan's thesis + some reruns (maybe 3?) 
% % CRONUS-A % Scatter - Sato Muons, ERA40, Sample Means, original ages (17.4 and 11.6 ka)
% % Fit as 1 group per B. Borchers - not site-by-site, weighted means of
% % samples - modified 09/20/11 - includes recalculation per Hippe et al and 
% % corrected del13C data
% 
% consts.P14_ref_St = 12.63;  
% consts.delP14_ref_St = 1.62;
% consts.P14_ref_Lm = 12.70; 
% consts.delP14_ref_Lm = 1.63;
% % consts.P14_ref_De = 13.25; 
% % consts.delP14_ref_De = 1.70;
% % consts.P14_ref_Du = 13.36; 
% % consts.delP14_ref_Du = 1.72;
% % consts.P14_ref_Li = 14.21; 
% % consts.delP14_ref_Li = 1.82;
% consts.P14_ref_LS = 12.98; 
% consts.delP14_ref_LS = 1.67;
% 
% % 
% consts.P26_ref_St = consts.P10_ref_St*6.75;
% consts.delP26_ref_St = consts.delP10_ref_St*6.75;
% consts.P26_ref_Lm = consts.P10_ref_Lm*6.75;
% consts.delP26_ref_Lm = consts.delP10_ref_Lm*6.75;
% % consts.P26_ref_De = consts.P10_ref_De*6.75;
% % consts.delP26_ref_De = consts.delP10_ref_De*6.75;
% % consts.P26_ref_Du = consts.P10_ref_Du*6.75;
% % consts.delP26_ref_Du = consts.delP10_ref_Du*6.75;
% % consts.P26_ref_Li = consts.P10_ref_Li*6.75;
% % consts.delP26_ref_Li = consts.delP10_ref_Li*6.75;
% consts.P26_ref_LS = consts.P10_ref_LS*6.75;
% consts.delP26_ref_LS = consts.delP10_ref_LS*6.75;
% 
% % Fit as 1 group per B. Borchers - not site-by-site
% 
% consts.P3_ref_St = 123.8;  
% consts.delP3_ref_St = 4.0;
% consts.P3_ref_Lm = 122.8; 
% consts.delP3_ref_Lm = 4.0;
% % consts.P3_ref_De = 128.9; 
% % consts.delP3_ref_De = 4.2;
% % consts.P3_ref_Du = 129.7; 
% % consts.delP3_ref_Du = 4.2;
% % consts.P3_ref_Li = 138; 
% % consts.delP3_ref_Li = 4.5;
% consts.P3_ref_LS = 124.9; 
% consts.delP3_ref_LS = 4.1;

% Atomic number densities (atoms target/g mineral)
% (Moles target * Avogadro's Number / Formula weight)

% Quartz (SiO2)
% consts.Natoms3 = 2.00456e22;
% consts.Natoms10 = 2.00456e22;
% consts.Natoms14 = 2.00456e22;
% consts.Natoms26 = 1.00228e22;

consts.NatomsQtzO = 2.00456e22;
consts.NatomsQtzSi = 1.00228e22;

% consts.NatomsQtzO = 2.006e22;
% consts.NatomsQtzSi = 1.003e22;

% Magnetite (Fe3O4)
consts.NatomsMagFe = 7.80297E+21;
consts.NatomsMagO = 1.04040E+22;

% Hematite (Fe2O3)
consts.NatomsHemFe = 7.54237E+21;
consts.NatomsHemO = 1.13136E+22;

% Rutile (TiO2)
consts.NatomsRutTi = 7.54033E+21;
consts.NatomsRutO = 1.50807E+22;

% Olivine (Forsterite - Mg2SiO4)
consts.NatomsOlFoMg = 8.56068E+21;
consts.NatomsOlFoSi = 4.28034E+21;
consts.NatomsOlFoO = 1.71214E+22;

% Olivine (Fayalite - Fe2SiO4)
consts.NatomsOlFaFe = 5.91063E+21;
consts.NatomsOlFaSi = 2.95532E+21;
consts.NatomsOlFaO = 1.18213E+22;

% Olivine Fo80Fa20 (0.8*Mg2SiO4 + 0.2*Fe2SiO4)
consts.NatomsOlFo80Mg = 6.28497E+21;
consts.NatomsOlFo80Fe = 1.57124E+21;
consts.NatomsOlFo80Si = 3.92810E+21;
consts.NatomsOlFo80O = 1.57124E+22;

% Pyroxene (Enstatite - MgSiO3)
consts.NatomsOPxEnMg = 5.99882E+21;
consts.NatomsOPxEnSi = 5.99882E+21;
consts.NatomsOPxEnO = 1.79965E+22;

% Pyroxene (Ferrosilite - FeSiO3)
consts.NatomsOPxFsFe = 4.56469E+21;
consts.NatomsOPxFsSi = 4.56469E+21;
consts.NatomsOPxFsO = 1.36941E+22;

% Pyroxene (Wollastonite - CaSiO3)
consts.NatomsCPxWoCa = 5.18427E+21;
consts.NatomsCPxWoSi = 5.18427E+21;
consts.NatomsCPxWoO = 1.55528E+22;

% Pyroxene (Augite - Ca(MgFeAl)(Si,Al)2O6)
consts.NatomsCPxAuCa = 2.55207E+21;
consts.NatomsCPxAuMg = 2.29686E+21;
consts.NatomsCPxAuFe = 5.10413E+20;
consts.NatomsCPxAuAl = 1.27603E+21;
consts.NatomsCPxAuSi = 4.84893E+21;
consts.NatomsCPxAuO = 1.53124E+22;

% K feldspar (KAlSi3O8)
consts.NatomsKSparK = 2.16366e21;
consts.NatomsKSparAl = 2.16366e21;
consts.NatomsKSparSi = 6.49097e21;
consts.NatomsKSparO = 1.73093e22;

% Na feldspar (albite - NaAlSi3O8)
consts.NatomsNaSparNa = 2.29657e21;
consts.NatomsNaSparAl = 2.29657e21;
consts.NatomsNaSparSi = 6.88972E+21;
consts.NatomsNaSparO = 1.83726E+22;

% Ca feldspar (anorthite - CaAl2Si2O8)
consts.NatomsCaSparCa = 2.16462E+21;
consts.NatomsCaSparAl = 4.32925E+21;
consts.NatomsCaSparSi = 4.32925E+21;
consts.NatomsCaSparO = 1.73170E+22;

% Limestone (CaCO3)
consts.NatomsLimeCa = 6.01691E+21;
consts.NatomsLimeC = 6.01691E+21;
consts.NatomsLimeO = 1.80507E+22;

% Muon interaction cross-sections. All now follow Balco 2017 except as noted.
% Note that the energy-dependence-of-muon-interaction-cross-section
% exponent alpha is treated as model-dependent -- it's internal to 
% P_mu_total.m and can't be passed.  

% consts.k_neg10 = 5.05e-4; %per Balco 2010 (online publication) update of 
%                         %constants file from 2.2 to 2.2.1
% consts.delk_neg10 = 0.35e-4; %per Balco 2010 (online publication) update of 
%                         %constants file from 2.2 to 2.2.1
% consts.k_neg26 = 0.296 * 0.6559 * 0.022;
% consts.delk_neg26 = 0.296 * 0.6559 * 0.002;

consts.k_negpartial_10 = (0.704 * 0.1828); % per Beacon Core Fit (Balco, 2017) 8/8/17 NL
consts.delk_negpartial_10 = (0.704 * 0.1828 * 0.0003); % per Beacon Core Fit (Balco, 2017) 8/8/17 NL
% consts.k_negpartial_10 = (0.704 * 0.1828)./1.106; % per CRONUScalc (Marrero et al., 2016)
% consts.delk_negpartial_10 = (0.704 * 0.1828 * 0.0003)./1.106; % per CRONUScalc (Marrero et al., 2016)
consts.k_negpartial_14 = 0.704 * 0.1828;
consts.delk_negpartial_14 = 0.704 * 0.1828 * 0.0011;
consts.k_negpartial_26 = 0.296 * 0.6559;
consts.delk_negpartial_26 = 0.296 * 0.6559 * 0.002;

% LSD nuclide-specific
    consts.fstar14.LS=0.114;  % per Balco (2017) 8/8/17 NL
	consts.fstar10.LS=1.92e-3; % per Beacon Core Fit (Balco, 2017) 8/8/17 NL
	consts.fstar26.LS=13.1e-3;  % per Beacon Core Fit (Balco, 2017) 8/8/17 NL
%   consts.fstar14.LS=0.137; %Not calibrated as part of CRONUS-Earth
% 	consts.fstar10.LS=1.89e-3; %CRONUScalc value - Phillips et al. 2016 (Synthesis paper)
% 	consts.fstar26.LS=12.1e-3; %CRONUScalc value - Phillips et al. 2016 (Synthesis paper)
	consts.fstar36K.LS=0.0577; %CRONUScalc value - Marrero et al., 2016 (36Cl calibration)
	consts.fstar36Ca.LS=0.0135; %CRONUScalc value - Marrero et al., 2016 (36Cl calibration)
	consts.sigma036K.LS=9.36e-30; %CRONUScalc value - Marrero et al., 2016 (36Cl calibration)
	consts.sigma036Ca.LS=8.25e-30; %CRONUScalc value - Marrero et al., 2016 (36Cl calibration)
	consts.sigma014.LS=0.45e-27./190; % per Balco (2017), after Heisinger et al. (2002) for alpha = 1 8/8/17 NL
    consts.sigma010.LS=0.237e-30;  % per Beacon Core Fit (Balco, 2017) 8/8/17 NL
	consts.sigma026.LS=3.26e-30;  % per Beacon Core Fit (Balco, 2017) 8/8/17 NL
% 	consts.sigma014.LS=8.79321E-30; %Not calibrated as part of CRONUS-Earth
%     consts.sigma010.LS=0.252e-30; %CRONUScalc value - Phillips et al. 2016 (Synthesis paper)
% 	consts.sigma026.LS=4.03e-30; %CRONUScalc value - Phillips et al. 2016 (Synthesis paper)

% Lm
	consts.fstar14.Lm=0.116; % per Balco (2017) 8/8/17 NL
	consts.fstar10.Lm=1.91e-3;  % per Beacon Core Fit (Balco, 2017) 8/8/17 NL
	consts.fstar26.Lm=13.3e-3;  % per Beacon Core Fit (Balco, 2017) 8/8/17 NL
% 	consts.fstar14.Lm=0.137; %Not calibrated as part of CRONUS
% 	consts.fstar10.Lm=1.87e-3; %CRONUScalc value - Phillips et al., 2016 (Synthesis paper)
% 	consts.fstar26.Lm=11.0e-3; %CRONUScalc value - Phillips et al., 2016 (Synthesis paper)
	consts.fstar36K.Lm=0.06146167;  %CRONUScalc value - Marrero et al., 2016 (36Cl calibration)
	consts.fstar36Ca.Lm=0.01416637;  %CRONUScalc value - Marrero et al., 2016 (36Cl calibration)
	consts.sigma036K.Lm=8.861757e-30;  %CRONUScalc value - Marrero et al., 2016 (36Cl calibration)
	consts.sigma036Ca.Lm=8.36167e-30;  %CRONUScalc value - Marrero et al., 2016 (36Cl calibration)
	consts.sigma014.Lm=0.45e-27./190; % per Balco (2017), after Heisinger et al. (2002) for alpha = 1 8/8/17 NL
	consts.sigma010.Lm=0.280e-30;  % per Beacon Core Fit (Balco, 2017) 8/8/17 NL
	consts.sigma026.Lm=3.89e-30;  % per Beacon Core Fit (Balco, 2017) 8/8/17 NL
% 	consts.sigma014.Lm=8.79321E-30; %Not calibrated as part of CRONUS
% 	consts.sigma010.Lm=0.251e-30; %CRONUScalc value - Phillips et al., 2016 (Synthesis paper)
% 	consts.sigma026.Lm=4.22e-30; %CRONUScalc value - Phillips et al., 2016 (Synthesis paper)

% St
	consts.fstar14.St=0.116; % per Balco (2017) 8/8/17 NL
	consts.fstar10.St=1.91e-3;  % per Beacon Core Fit (Balco, 2017) 8/8/17 NL
	consts.fstar26.St=13.3e-3;  % per Beacon Core Fit (Balco, 2017) 8/8/17 NL
% 	consts.fstar14.St=0.137; %Not calibrated as part of CRONUS
% 	consts.fstar10.St=1.87e-3; %CRONUScalc value - Phillips et al., 2016 (Synthesis paper)
% 	consts.fstar26.St=10.9e-3; %CRONUScalc value - Phillips et al., 2016 (Synthesis paper)
	consts.fstar36K.St=0.05830165;  %CRONUScalc value - Marrero et al., 2016 (36Cl calibration)
	consts.fstar36Ca.St=0.0135710;  %CRONUScalc value - Marrero et al., 2016 (36Cl calibration)
	consts.sigma036K.St=9.253363e-30;  %CRONUScalc value - Marrero et al., 2016 (36Cl calibration)
	consts.sigma036Ca.St=8.254806e-30;  %CRONUScalc value - Marrero et al., 2016 (36Cl calibration)
	consts.sigma014.St=0.45e-27./190; % per Balco (2017), after Heisinger et al. (2002) for alpha = 1 8/8/17 NL
	consts.sigma010.St=0.280e-30; % per Beacon Core Fit (Balco, 2017) 8/8/17 NL
	consts.sigma026.St=3.89e-30; % per Beacon Core Fit (Balco, 2017) 8/8/17 NL
% 	consts.sigma014.St=8.79321E-30; %Not calibrated as part of CRONUS
% 	consts.sigma010.St=0.251e-30; %CRONUScalc value - Phillips et al., 2016 (Synthesis paper)
% 	consts.sigma026.St=4.22e-30; %CRONUScalc value - Phillips et al., 2016 (Synthesis paper)

% consts.k_neg10 =0.00192 .* 0.704 .* 0.1828; % From BCO fit
% consts.delk_neg10 = 0.00192.*0.05 .* 0.704 .* 0.1828; % From BCO fit
% 
% consts.k_neg14 = 0.704 * 0.1828 * 0.114; % f* value fit from Balco 2017
% consts.delk_neg14 = 0.704 * 0.1828 * 0.0011; %uncertainty from Heisinger et al. (2002)
% 
% consts.k_neg26 = 0.0131 .* 0.296 .* 0.6559; % From BCO fit
% consts.delk_neg26 = 0.0131.*0.105 .* 0.296 .* 0.6559; % From BCO fit
% 
% consts.sigma0_10 = 0.237e-30; % From BCO fit
% consts.delsigma0_10 = 0.237e-30.*0.05; % From BCO fit
% 
% consts.sigma0_14 = 0.45e-27./190;
% consts.delsigma0_14 = 0.25e-27./190;
% 
% consts.sigma0_26 = 3.26e-30; % From BCO fit
% consts.delsigma0_26 = 3.26e-30.*0.105; % From BCO fit;

% Spallogenic Nuclide Production Cross-Sections (n & p) from Bob Reedy 9/2010

% load XSectsReedyAll; 
% load XSectsReedyAll120113; 
% load XSectsReedyAllKMod; 
% load XSectsReedyAllKuni;

%include 21Ne cross-sections
% High-resolution cross-sections (800 energy bins instead of original 200)
load XSectionsHiRes;

consts.E = E;

consts.O16nxBe10 = Onx10Be;
consts.O16pxBe10 = Opx10Be;
consts.SinxBe10 = Sinx10Be;
consts.SipxBe10 = Sipx10Be;
consts.FenxBe10 = Fenx10Be;
consts.FepxBe10 = Fepx10Be;

consts.O16nn2pC14 = Onn2p14C;
consts.O16pxC14 = Opx14C;
consts.SinxC14 = Sinx14C;
consts.SipxC14 = Sipx14C;

consts.Aln2nAl26 = Aln2n26Al;
consts.AlppnAl26 = Alppn26Al;
consts.SinxAl26 = Sinx26Al;
consts.SipxAl26 = Sipx26Al;

consts.KnxCl36 = Knx36Cl;
consts.KpxCl36 = Kpx36Cl;
consts.CanapCl36 = Canap36Cl;
consts.CapxCl36 = Capx36Cl;
consts.FenxCl36 = Fenx36Cl;
consts.FepxCl36 = Fepx36Cl;
consts.TinxCl36 = Tinx36Cl;
consts.TipxCl36 = Tipx36Cl;

consts.MgnxNe21 = Mgnx21Ne;
consts.MgpxNe21 = Mgpx21Ne;
consts.AlnxNe21 = Alnx21Ne;
consts.AlpxNe21 = Alpx21Ne;
consts.SinxNe21 = Sinx21Ne;
consts.SipxNe21 = Sipx21Ne;
consts.FenxNe21 = Fenx21Ne;
consts.FepxNe21 = Fepx21Ne;
consts.CanxNe21 = Canx21Ne;
consts.CapxNe21 = Capx21Ne;

consts.OnxHe3T = Onx3HeT;
consts.OpxHe3T = Opx3HeT;
consts.SinxHe3T = Sinx3HeT;
consts.SipxHe3T = Sipx3HeT;
consts.AlnxHe3T = Alnx3HeT;
consts.AlpxHe3T = Alpx3HeT;
consts.MgnxHe3T = Mgnx3HeT;
consts.MgpxHe3T = Mgpx3HeT;
consts.CanxHe3T = Canx3HeT;
consts.CapxHe3T = Capx3HeT;
consts.FenxHe3T = Fenx3HeT;
consts.FepxHe3T = Fepx3HeT;

% Paleomagnetic records for use in time-dependent production rate schemes
% Derived from Nat Lifton's compilation of paleomagnetic data from
% various sources. See Lifton et al. (2006) and Pigati and Lifton (2005).

% Load the magnetic field data - 

% load PMag_Sep12 %no adjustment for 10% geographical bias, incl. Dunai version - CALS3K.3, CALS7K.2, GLOPIS-75 to 18ka, PADM2M >18 ka, 1950-2010 Rc
% %     Dec11 version includes updated SPhi values from Usoskin et al, 2011, Journal of Geophysical Research, v. 116, no. A2. Changed end value of
% %     t_M from Inf to 1e7 to enable to run in MATLAB 2012a and later. 
% load PMag_Jul13b %CALS3k.4 to 2900 yr bp, CALS10k.1b to 10kyr, PADM2M >10 ka, 1950-2010 Rc. Updated S and SPhi temporal spacing to match.

% load PMag_Aug13 %CALS3k.4 to 2900 yr bp, CALS10k.1b to 10kyr, PADM2M >10 ka, 1950-2010 Rc. Updated S and SPhi temporal spacing to match. 
% %       Fixed latitude offset in PMag_Jul13b

load PavonPmag %Pavon to 14kyr, GLOPIS-75 to 75 ka, PADM2M to 2Ma, 1950-2010 Rc. Same S and SPhi temporal spacing as PMag_Aug13. 7/11/14
%       

% Relative dipole moment and time vector - Pavon 7/11/14
consts.GLOPADMM0 = GLOPADMM0; 
consts.tM = tM; 

% % Aug13 values - PADM2M
% consts.PADM2MM0 = PADM2MM0; 
% consts.tM = tM; 

% consts.t_fineRc = t_fineRc;
% These start at 7000 yr -- time slices are 100-yr from 7000 to 50000
% in order to use 100-yr-averaged data from GLOPIS-75 (to 18 ka) and PADM2M (>18 ka); subsequent time 
% slices are 50000:1000:2000000 for 
% PADM2M data; final two time points are 2001000 and 1e7. - Nat Lifton

% Cutoff rigidity blocks for past 6900 yr. 
% TTRc and IHRC are lon x lat x time blocks of Rc values for the past 
% 6900 years.
% Both are derived by Nat Lifton from the magnetic field reconstructions of
% Korte and Constable. 
% TTRC has cutoff rigidity obtained by trajectory tracing -- these are for
% the Lifton and Desilets scaling factors. IHRc has cutoff rigidity
% obtained by finding magnetic inclination and horizontal field strength
% from the field model, then applying Equation 2 of Dunai(2001). 
% consts.KC3k10kRc = KC3k10kRc; % data block
consts.PavonRc = PavonRc; % data block - 7/11/14
% consts.TTRc = TTRc; % data block
% consts.IHRc = IHRc; % data block
consts.lat_Rc = lat_Rc; % lat and lon indices for Rc data block
consts.lon_Rc = lon_Rc;
consts.tRc = tRc; % time vector for Rc data block

% Matrix for interpolating effective Rc skymap value from a given trajectory-traced Rc value
% as a function of latitude - 5/3/14
load LatRc
consts.lat = lat;
consts.Rcveff = Rcveff;
consts.LatRc = LatRc;


% % Effective pole positions and field strengths inferred from K and C field
% % reconstructions for last 7000 yr. These are used in the
% % paleomagnetically-corrected implementation of the Lal SF. They are for
% % the same times as the RC slices in the data block above. Again,
% % generated by Nat Lifton -- hence KCL = Korte-Constable-Lifton. 
% 
% consts.MM0_KCL = MM0_KCL;
% consts.lat_pp_KCL = lat_pp_KCL;
% consts.lon_pp_KCL = lon_pp_KCL;
% 
% Effective pole positions and field strengths inferred from Pavon field
% reconstructions for last 14000 yr. These are used in the
% paleomagnetically-corrected implementation of the Lal SF. They are for
% the same times as the RC slices in the data block above. Generated by Nat Lifton

consts.MM0_Pavon = MM0_Pavon;
consts.lat_pp_Pavon = lat_pp_Pavon;
consts.lon_pp_Pavon = lon_pp_Pavon;


% Solar variability from Lifton et al. 2005
% Truncated at 11000 yr - 100-yr spacing
consts.S = S; 
consts.SInf = 0.939; % Long-term mean S value;

% Changed 12/13/11 to reflect updated SPhi values from Usoskin et al 2011
% Solar variability from Usoskin et al. 2011
% 0-11400 yr - 100-yr spacing

%Per Tatsuhiko Sato, personal communication, 2013, convert annually
%averaged Usoskin et al. (2011)
%solar modulation potential to Sato Force Field Potential due to different
%assumed Local Interstellar Spectrum and other factors

SPhi = 1.1381076.*SPhi - 1.2738468e-4.*SPhi.^2;

consts.SPhi = SPhi;
consts.SPhiInf = mean(SPhi);% Changed 12/13/11 to reflect updated SPhi values from Usoskin et al. (2011)

% load ReferenceTgt

%Calculated reference PRs using hi-resolution cross-sections (800 energy
%bins instead of original 200, per Argento et al., 2015) 7/20/15
load ReferenceTgtHR
%Reference values for scaling via Sato et al. (2008) spectra
% consts.E = E;
consts.P3nRef_q = P3nRef_q; %3He neutron reference production in SiO2
consts.P3pRef_q = P3pRef_q; %3He proton reference production in SiO2
consts.P3nRef_fo = P3nRef_fo; %3He neutron reference production in Forsterite (MgSiO4)
consts.P3pRef_fo = P3pRef_fo; %3He proton reference production in Forsterite (MgSiO4)
consts.P3nRef_fa = P3nRef_fa; %3He neutron reference production in Fayalite (FeSiO4)
consts.P3pRef_fa = P3pRef_fa; %3He proton reference production in Fayalite (FeSiO4)
consts.P3nRef_f8 = P3nRef_f8; %3He neutron reference production in 80% Fo
consts.P3pRef_f8 = P3pRef_f8; %3He proton reference production in 80% Fo
consts.P3nRef_en = P3nRef_en; %3He neutron reference production in Enstatite (MgSiO3)
consts.P3pRef_en = P3pRef_en; %3He proton reference production in Enstatite (MgSiO3)
consts.P3nRef_fs = P3nRef_fs; %3He neutron reference production in Ferrosilite (FeSiO3)
consts.P3pRef_fs = P3pRef_fs; %3He proton reference production in Ferrosilite (FeSiO3)
consts.P3nRef_wo = P3nRef_wo; %3He neutron reference production in Wollastonite (CaSiO3)
consts.P3pRef_wo = P3pRef_wo; %3He proton reference production in Wollastonite (CaSiO3)
consts.P3nRef_au = P3nRef_au; %3He neutron reference production in Augite Ca(Mg,Fe,Al)(Si,Al)2O6
consts.P3pRef_au = P3pRef_au; %3He proton reference production in Augite Ca(Mg,Fe,Al)(Si,Al)2O6
consts.P3nRef_m = P3nRef_m; %3He neutron reference production in Magnetite (Fe3O4)
consts.P3pRef_m = P3pRef_m; %3He proton reference production in Magnetite (Fe3O4)
consts.P10nRef_q = P10nRef_q; %10Be neutron reference production in SiO2
consts.P10pRef_q = P10pRef_q; %10Be proton reference production in SiO2
consts.P10nRef_m = P10nRef_m; %10Be neutron reference production in Magnetite (Fe3O4)
consts.P10pRef_m = P10pRef_m; %10Be proton reference production in Magnetite (Fe3O4)
consts.P14nRef_q = P14nRef_q; %14C neutron reference production in SiO2
consts.P14pRef_q = P14pRef_q; %14C proton reference production in SiO2
consts.P26nRef_q = P26nRef_q; %26Al neutron reference production in SiO2
consts.P26pRef_q = P26pRef_q; %26Al proton reference production in SiO2
% Need to add in 21Ne in SiO2 at least!
consts.nfluxRef = nfluxRef; %integral reference neutron flux
consts.pfluxRef = pfluxRef; %integral reference proton flux
consts.ethfluxRef = ethfluxRef; %integral reference epithermal flux
consts.thfluxRef = thfluxRef; %integral reference thermal neutron flux
consts.mfluxRef = mfluxRef; % reference muon flux components

% Finish up

save consts_LSDPavonTgt consts

disp(['Constants version ' consts.version]);
disp('Saved'); 


