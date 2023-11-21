function [ice_hist,ts] = define_ice_history(scenario,dt)

% This function loads some pre-defined potential ice-cover scenarios for 
% Riukojietna Ice Cap, Northern Sweden.

% Developed by Allie Koester, Purdue University (kostea@purdue.edu) and 
% Jane Lund Andersen, Aarhus University (jane.lund@geo.au.dk), 2021-23

switch scenario
    case 1 %Finse (8.2 ka) re-advance
        ice_times=[20000 10000 8500 8000 7500 2500 105 55 37 0]; %time fixpoints (years prior to 2015)
        ice_cover=[200 0 0 40 0 0 35 25 19 0]*100; %Ice thickness at times in ice_times (cm)

    case 2 %complete deglaciation at 8 ka
        ice_times=[20000 8000 2500 105 55 37 0]; %time fixpoints (years prior to 2015)
        ice_cover=[200 0 0 35 25 19 0]*100; %Ice thickness at times in ice_times (cm)   

    case 3 %simple case following LOI in lake (too little exposure)
        ice_times=[20000 8000 5000 2500 105 55 37 0]; %time fixpoints (years prior to 2015)
        ice_cover=[200 35 0 0 35 25 19 0]*100; %Ice thickness at times in ice_times (cm)   

    case 4 %MIS3 exposure
        ice_times=[55000 35000 20000 8000 5000 2500 105 55 37 0]; %time fixpoints (years prior to 2015)
        ice_cover=[0 0 200 35 0 0 35 25 19 0]*100; %Ice thickness at times in ice_times (cm)
        
    case 5 %UMISM ice retreat 20000 to 10400
        ice_times=[71000 57000 35000 20000    18000   16000   14000   12900   12500   11000   10800   10700   10600   10500   10400   10300   10000   8000    7900    1900    1800    105 55  37  0];
        ice_cover=[900 0 0 901  943 917 608 613 741 506 437 376 258 171 95  40  40  33  0   0   33  33  32  30  0]*100; %add 40 m to ts 10400 and 10300
            %added the minimum amount for 003 and 004 to the ice thickness

    case 6 % reconstruction based on lake-core
        ice_times=[20000 9900 9800 7800 7790 5010 5000 4510 4500 1800 1750 105 55 37 0]; %time fixpoints (years prior to 2015)
        ice_cover=[200 50 34 34 0 0 34 34 0 0 34 34 25 19 0]*100; %Ice thickness at times in ice_times (cm)

end

ts = (ice_times(1)-1):-dt:0; %time vector for calculations
ice_hist=interp1(ice_times,ice_cover,ts); %interpolate ice-thickness at times in time vector