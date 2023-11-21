
% This script compiles 10Be-26Al-14C production rates and saves them into a
% structure for later use.

% Developed by Jane Lund Andersen, Aarhus University (jane.lund@geo.au.dk),
% and Allie Koester, Purdue University (kostea@purdue.edu), 2021-23

clear, close all
% addpath("Functions/","Functions/Spectra/") %Add subfolders with key functions

Ns=5; %number of samples

%% Calculate C production:
run Balculator_c_be_LSDLal.m 
% This function will ask for an input file with C and Be data ("riuko_CBefin.txt")
% make sure the file is in format: sample name, lat, long, elevation, 
% pressure (std), sample thickness, density, shielding, erosion rate, 
% N14, dN14, N10, dN10, Be standard name

%pack sample and production parameters in a cell structure for each sample
for i=1:Ns 
    samples{i}.name=all_sample_name(i);
    samples{i}.lat=all_lat(i); 
    samples{i}.long=all_long(i);
    samples{i}.elv=all_elv(i); 
    samples{i}.aa=all_aa(i); 
    samples{i}.thick=all_thick(i);
    samples{i}.rho=all_rho(i); 
    samples{i}.shielding=all_shielding(i);    
    samples{i}.E=all_E(i); 
    samples{i}.N14=all_N14(i);
    samples{i}.dN14=all_delN14(i); 
    samples{i}.N10=all_N10(i);
    samples{i}.dN10=all_delN10(i); 
    samples{i}.be_std_name=all_be_std_name(i);
    samples{i}.FSF14_Lm=FSF14_Lm(i);
    samples{i}.FSF14_LS=FSF14_LS(i);
    samples{i}.FSF14_St=FSF14_St(i);
    samples{i}.P14fm_St = c_results.P_fast_St;
    samples{i}.P14fm_LS = c_results.P_fast_LS;
    samples{i}.P14fm_Lm = c_results.P_fast_Lm;
    samples{i}.P14nmc_St = c_results.P_neg_St;
    samples{i}.P14nmc_LS = c_results.P_neg_LS;
    samples{i}.P14nmc_Lm = c_results.P_neg_Lm;
end

%% Calculate Be and Al production:
run Balculator_be_al_LSDLal.m 
% This function will ask for an input file with Be-Al data ("riuko_BeAlfin.txt")
% make sure the file is in format: sample name, lat, long, elevation, 
% pressure (std), sample thickness, density, shielding, erosion rate, 
% N10, dN10, N26, dN26, Be standard name

%Add Be-10 and Al-26 production parameters to samples structure
for i=1:Ns 
    samples{i}.N26=all_N26(i);
    samples{i}.dN26=all_delN26(i);
    samples{i}.al_std_name = all_al_std_name(i);    
    samples{i}.FSF10_Lm=FSF10_Lm(i);
    samples{i}.FSF10_LS=FSF10_LS(i);
    samples{i}.FSF10_St=FSF10_St(i);
    samples{i}.P10fm_St = be_results.P_fast_St;
    samples{i}.P10fm_LS = be_results.P_fast_LS;
    samples{i}.P10fm_Lm = be_results.P_fast_Lm;
    samples{i}.P10nmc_St = be_results.P_neg_St;
    samples{i}.P10nmc_LS = be_results.P_neg_LS;
    samples{i}.P10nmc_Lm = be_results.P_neg_Lm;
    samples{i}.FSF26_Lm=FSF26_Lm(i);
    samples{i}.FSF26_LS=FSF26_LS(i);
    samples{i}.FSF26_St=FSF26_St(i);
    samples{i}.P26fm_St = al_results.P_fast_St;
    samples{i}.P26fm_LS = al_results.P_fast_LS;
    samples{i}.P26fm_Lm = al_results.P_fast_Lm;
    samples{i}.P26nmc_St = al_results.P_neg_St;
    samples{i}.P26nmc_LS = al_results.P_neg_LS;
    samples{i}.P26nmc_Lm = al_results.P_neg_Lm;
end

%% save Be and Al production
save RiukoProduction.mat consts samples
