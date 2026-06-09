function [N14C,N10Be,N26Al] = forward_CN_bedrock(ts,ice_hist,Esubgla,sampledata,tv,consts)

% This function returns the calculated cosmogenic nuclide inventory 
% (10Be-26Al-14C) in a surface sample over time as it is subaerially
% exposed or covered by (thin) ice (with or without subglacial erosion).
% The function uses the LSD scaling scheme by Lifton et al., 2014, but this
% can be replaced by substituting all occurrences of 'LS' with 
% 'St' (Stone 2000) or 'Lm' (Lal 1991/Stone 2000 time-dependent)

% Input variables: 
% consts: constants file for production generated from running the 
% compile_production.m file (saved in RiukoProduction.mat);
% sampledata: sample and production parameters compiled when running the 
% compile_production.m file (saved in RiukoProduction.mat); 
% tv: time vector for production vectors
% ts: time vector; 
% ice_hist: ice thickness for times in ts; 
% Esubgla: Subglacial erosion rate [cm/yr], can be set to 0 [Note: 
% only if ice thickness>25 m, this value can be changed below]

% Output variables: N14C, N10Be, N26Al are calculated
% nuclide inventories in bedrock samples at times in ts

% Developed by Jane Lund Andersen, Aarhus University (jane.lund@geo.au.dk)
% and Allie Koester, Purdue University (kostea@purdue.edu), 2021-23

%% Load and define constants
dc14 = consts.l14; %decay constant for 14C
dc10 = consts.l10; %decay constant for 10Be
dc26 = consts.l26; %decay constant for 26Al
Lsp = 140; %attenuation length for spallation, Low Rc, per Lifton et al., 2014 Table 1
rho_ice = 0.92; %g/cm3 density of ice
rho_br = sampledata.rho; %g/cm3 density of bedrock


%% calculate spallation surface production
P14_sp(:,:) = sampledata.SF14_LS(:,:).*consts.P14_ref_LS; %spallation production at surface
P10_sp(:,:) = sampledata.SF10_LS(:,:).*consts.P10_ref_LS; 
P26_sp(:,:) = sampledata.SF26_LS(:,:).*consts.P26_ref_LS;

%% Interpolate scaling factor arrays to ts time vector
P14_sp2 = interp1(tv.C,P14_sp,ts); %interpolate spallation production at times in time vector
P10_sp2 = interp1(tv.Be,P10_sp,ts); %interpolate spallation production at times in time vector
P26_sp2 = interp1(tv.Al,P26_sp,ts); %interpolate spallation production at times in time vector

%% Calculate depth of sample over time as a function of the subglacial 
% erosion rate (Esubgla) and whether the sample is below ice thicker than:
erosiveIce=25; %Threshold value for erosive ice (m)

% Faster method:
Ise=find(diff(sign(ice_hist/1e2-erosiveIce))); %find indices for subglacial erosion on/off
temp=sign(ice_hist/1e2-erosiveIce); Ise=Ise(abs(temp(Ise))>0); %remove exact zero's
Tse=[ts(1) ts(Ise) ts(end)]; %times for subglacial erosion on/off
dTs=abs(diff(Tse)); %length of periods
dtGE=dTs(end-1:-2:1); %length of glac. erosive periods assuming exposure during most recent period
Zs=Esubgla*sum(dtGE); %depths for subglacial erosion on/off extended below
for i=1:length(dtGE)-1
    Zs=[Zs Esubgla*sum(dtGE(1:end-i)) Esubgla*sum(dtGE(1:end-i))]; 
end
Zs=[Zs 0 0]; %Assuming exposure during most recent period
burial=interp1(Tse,Zs,ts);

% Overburden of rock and ice [g/cm2] at times in ts
overburden=rho_ice*ice_hist+rho_br*burial;

%% calculate pressure at each site for muon code

if (strcmp(sampledata.aa,'std'))
    sampledata.pressure = ERA40atm(sampledata.lat,sampledata.long,sampledata.elv);
elseif (strcmp(sampledata.aa,'ant'))
    sampledata.pressure = antatm(sampledata.elv);
end

%% Muon production with depth for Be10

% constants structure for Be10 muon production rate
mconsts.Natoms = consts.NatomsQtzO;
mconsts.sigma0 = consts.sigma010.LS;
mconsts.fstar = consts.fstar10.LS;
mconsts.k_negpartial = consts.k_negpartial_10;
mconsts.mfluxRef = consts.mfluxRef;
Rc=0.032; %Based on consts.PavonRc for 70N, 15E (Riukojietna 68N, 18E) time-averaged

% calculate muon production in each timestep under prescribed ice and rock burial depth
P10_mu_depth = P_mu_total_alpha1(overburden,sampledata.pressure,mconsts,'no');

%% Muon production with ice depth for Al26

% constants structure for Al26 muon production rate
mconsts.Natoms = consts.NatomsQtzSi;
mconsts.sigma0 = consts.sigma026.LS;
mconsts.fstar = consts.fstar26.LS;
mconsts.k_negpartial = consts.k_negpartial_26;
mconsts.mfluxRef = consts.mfluxRef;

% calculate muon production in each timestep under prescribed ice and rock burial depth
P26_mu_depth = P_mu_total_alpha1(overburden,sampledata.pressure,mconsts,'no');

%% Muon production with depth for C14

% constants structure for C14 muon production rate
mconsts.Natoms = consts.NatomsQtzO;
mconsts.sigma0 = consts.sigma014.LS;
mconsts.fstar = consts.fstar14.LS;
mconsts.k_negpartial = consts.k_negpartial_14;
mconsts.mfluxRef = consts.mfluxRef;

% calculate muon production in each timestep under prescribed ice and rock burial depth
P14_mu_depth = P_mu_total_alpha1(overburden,sampledata.pressure,mconsts,'no');

%% calculate total production corrected for ice and rock shielding over time
P10_tot = P10_sp2.*exp(-overburden./Lsp) + P10_mu_depth;
P26_tot = P26_sp2.*exp(-overburden./Lsp) + P26_mu_depth;
P14_tot = P14_sp2.*exp(-overburden./Lsp) + P14_mu_depth;

%% preallocate for simulation
N14C = zeros(size(ts)); %preallocate
N10Be = zeros(size(ts)); %preallocate
N26Al = zeros(size(ts)); %preallocate
dt=ts(end-1)-ts(end); %time step length

%% Calculate the surface concentration over time with prescribed ice and rock shielding 
for j = 1:length(ts)
    if j == 1 %first time step (starts at zero -> no decay)
        N14C(j) = (P14_tot(j)/dc14).*(1-exp(-dc14.*dt)); 
        N10Be(j) = (P10_tot(j)/dc10).*(1-exp(-dc10.*dt));
        N26Al(j) = (P26_tot(j)/dc26).*(1-exp(-dc26.*dt));
    else % decay since last timestep plus production in this time step
        N14C(j) = (N14C(j-1).*exp(-dc14.*dt)) + (P14_tot(j)/dc14).*(1-exp(-dc14.*dt));
        N10Be(j) = (N10Be(j-1).*exp(-dc10.*dt)) + (P10_tot(j)/dc10).*(1-exp(-dc10.*dt));
        N26Al(j) = (N26Al(j-1).*exp(-dc26.*dt)) + (P26_tot(j)/dc26).*(1-exp(-dc26.*dt));
    end
end