
% This script compiles 10Be-26Al-14C production rates and saves them into a
% structure for later use.

% Developed by Jane Lund Andersen, Aarhus University (jane.lund@geo.au.dk),
% Allie Koester (kostea@purdue.edu), and Nat Lifton (nlifton@purdue.edu),
% Purdue University, 2021-24

clear, close all
% addpath("Functions/","Functions/Spectra/") %Add subfolders with key functions

Ns=5; %number of samples

%% Calculate C production:
run C_Prod.m 
% This function will ask for an input file with C data ("riuko_C.txt")
% make sure the file is in format: sample name, lat, long, elevation, 
% pressure (std), sample thickness, density, shielding, erosion rate, 
% N14, dN14

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
    samples{i}.SF14_LS=SF14_LS(i,:); %Use time vector of scaling factors
end

%% Calculate Be and Al production:
run Be_Al_Prod.m 
% This function will ask for an input file with Be-Al data ("riuko_BeAl.txt")
% make sure the file is in format: sample name, lat, long, elevation, 
% pressure (std), sample thickness, density, shielding, erosion rate, 
% N10, dN10, Be standard name, N26, dN26, Al standard name

%Add Be-10 and Al-26 production parameters to samples structure
for i=1:Ns 
    samples{i}.N10=all_N10(i);
    samples{i}.dN10=all_delN10(i); 
    samples{i}.be_std_name=all_be_std_name(i);
    samples{i}.N26=all_N26(i);
    samples{i}.dN26=all_delN26(i);
    samples{i}.al_std_name = all_al_std_name(i);    
    samples{i}.SF10_LS=SF10_LS(i,:); %Use time vector of scaling factors
    samples{i}.SF26_LS=SF26_LS(i,:); %Use time vector of scaling factors
end

tv.C = t14;
tv.Be = t10;
tv.Al = t26;

%% save Be and Al production
save RiukoProduction.mat consts samples tv
