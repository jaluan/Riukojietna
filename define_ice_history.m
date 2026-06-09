function [ice_hist,ts] = define_ice_history(scenario,dt)

% This function loads some pre-defined potential ice-cover scenarios for 
% Riukojietna Ice Cap, Northern Sweden.

% Developed by Allie Koester, Purdue University (kostea@purdue.edu) and 
% Jane Lund Andersen, Aarhus University (jane.lund@geo.au.dk), 2021-23

switch scenario

    case 1 % reconstruction based on lake-core (changed lake deglaciation to 8.1 ka from 7.8 ka originally - NL 08/25, 
        % changed mid-Holocene re-advance timing from 5.0-4.5 cal ka to 5.4-5.0 cal ka, per APS - NL 01/26)
        ice_times=[20000 9900 9800 8100 8090 5410 5400 5010 5000 1800 1750 105 55 37 0]; %time fixpoints (years prior to 2015)
        ice_cover=[200 50 34 34 0 0 34 34 0 0 34 34 25 19 0]*100; %Ice thickness at times in ice_times (cm)

    case 2 % reconstruction based on lake-core (changed lake deglaciation to 8.1 ka from 7.8 ka originally, no mid-Holocene readvance - NL 09/25)
        ice_times=[20000 9900 9800 8100 8090 5410 5400 5010 5000 1800 1750 105 55 37 0]; %time fixpoints (years prior to 2015)
        ice_cover=[200 50 34 34 0 0 0 0 0 0 34 34 25 19 0]*100; %Ice thickness at times in ice_times (cm) - no Mid-Holocene readvance

end

ts = (ice_times(1)-1):-dt:0; %time vector for calculations
ice_hist=interp1(ice_times,ice_cover,ts); %interpolate ice-thickness at times in time vector