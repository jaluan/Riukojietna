%C_Prod

%Time-dependent production rate calculator using LSDn scaling 
% (Lifton et al., 2014; Lifton 2016)
% 
%Based on stone_ager -- Script that performs exposure calculations, 
%similar to that on the web. Data should be saved as a text file using the 
%formatting required by the Balco et al. (2008) v2.2 web calculator. 
%The script does not perform the same error checks that the webcalc 
%performs, so be a good person and follow all the rules. 
%The ages and data are saved in five files, two for the Be 
%data (time dependent and non-time dependent) and the same for C. 
% All files are saved in the current
%Matlab directory.
%
%
%Written by Brent Goehring, 2007
%Lamont-Doherty Earth Observatory
%The script relies heavily on the CRONUS-Earth web calc toolbox written by 
%Greg Balco, Unversity of Washington  and will not run with out all scripts. 
%Does not perform erosion calculations.

%Load the data to be used. For consistency sake, use the same format that
%Balco requires for the web calc. The data set should be saved as a txt
%file in a directory Matlab can see.

% Modified by Nat Lifton 2024 to work with LSDn scaling (LS and LD)

% file = input('Please enter the name of the sample data file','s');
file='riuko_C.txt'; 
FID = fopen(file);
data = textscan(FID,'%s %n %n %n %s %n %n %n %n %n %n');
fclose(FID);
dstring='';

%Make the sample structure.

all_sample_name = data{1};
all_lat = data{2}; 
all_long = data{3};
all_elv = data{4}; 
all_pressure = data{4};
all_aa = data{5}; 
all_thick = data{6};
all_rho = data{7}; 
all_shielding = data{8};    
all_E = data{9}; 
all_N14 = data{10};
all_delN14 = data{11}; 

%Make the constants file.

% make_consts_LSD;
load consts_LSDn;

num_samples = length(all_lat);

% determine which nuclides were submitted --
for a = 1:num_samples	
	if all_N14(a) ~= 0
		all_isN14(a) = 1; 
        nuclide = 14;
    else
		all_isN14(a) = 0; 
    end

	if all_delN14(a) ~= 0
		all_isdelN14(a) = 1; 
    else
		all_isdelN14(a) = 0; 
    end
		
	% catch mismatches;
	
	if (~all_isN14(a))
   		error(['Need  C-14 concentration - line ' int2str(a)]);
	elseif (all_isN14(a) && ~all_isdelN14(a)) || (~all_isN14(a) && all_isdelN14(a));
    		error(['Need both C-14 concentration and uncertainty - line ' int2str(a)]);
    end
end

%Determine production rates

for a = 1:num_samples
    sample.sample_name = all_sample_name{a};
    sample.lat = all_lat(a);
    sample.long = all_long(a);
    sample.aa = all_aa{a};
    if strcmp(all_aa{a},'std') || strcmp(all_aa{a},'ant')
			% store the elevation value
			sample.elv = all_elv(a);
	elseif  strcmp(all_aa{a},'pre')
			% store the pressure value
			sample.pressure = all_pressure(a);
    end
    sample.thick = all_thick(a);
    sample.E = all_E(a);
    sample.rho = all_rho(a);
    sample.shielding = all_shielding(a);
    if all_isN14(a)
		sample.N14 = all_N14(a);
		sample.delN14 = all_delN14(a);
    end
  
%% Geomag and Spectra Calculations

     if (all_isN14(a))
		nuclide = 14;
        disp(strcat('14C: Calculating Geomagnetic Scaling and Cosmic-Ray Spectra, Sample_',num2str(a)));
        geomag = ScalingLSD(sample,consts,nuclide);
    end
		
	% sort the results that will appear in multiple-sample output;
        
    t14 = geomag.tv;
	if(all_isN14(a))
		% SF-dependent
        for b = 1:2
            SF14_LS(a,:) = geomag.SF_LS;
            SF14_LD(a,:) = geomag.SF_LD;
            % time vector and PR vector - that's it
        end
    end    
	
end % End of main calculation loop -- 

