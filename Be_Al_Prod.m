% Be_Al_Prod

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
%Balco requires for the web calc v2.2. The data set should be saved as a txt
%file in a directory Matlab can see.

% Modified by Nat Lifton 2024 to work with LSDn scaling (LS and LD)

% file = input('Please enter the name of the sample data file','s');
file='riuko_BeAl.txt'; 
FID = fopen(file);
data = textscan(FID,'%s %n %n %n %s %n %n %n %n %n %n %s %n %n %s');
fclose(FID);
dstring='';

%Make the sample structure.
%sample.name = input('Paste vector of sample names','s');

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
all_N10 = data{10};
all_delN10 = data{11}; 
all_be_std_name = data{12};
all_N26 = data{13};
all_delN26 = data{14}; 
all_al_std_name = data{15};


%Make the constants file.

% make_consts_LSD;
load consts_LSDn;


num_samples = length(all_lat);

% determine which nuclides were submitted --
for a = 1:num_samples	
	if all_N26(a) ~= 0
		all_isN26(a) = 1; 
    else
		all_isN26(a) = 0; 
    end

	if all_delN26(a) ~= 0
		all_isdelN26(a) = 1; 
    else
		all_isdelN26(a) = 0; 
    end
	
	if all_N10(a) ~= 0
		all_isN10(a) = 1;
    else
		all_isN10(a) = 0;
    end

	if all_delN10(a) ~= 0
		all_isdelN10(a) = 1; 
    else
		all_isdelN10(a) = 0; 
    end
	
	% catch mismatches;
	
	if (~all_isN26(a) && ~all_isN10(a))
   		error(['Need either Al-26 or Be-10 concentration - line ' int2str(a)]);
	elseif (all_isN26(a) && ~all_isdelN26(a)) || (~all_isN26(a) && all_isdelN26(a));
    		error(['Need both Al-26 concentration and uncertainty - line ' int2str(a)]);
	elseif (all_isN10(a) && ~all_isdelN10(a)) || (~all_isN10(a) && all_isdelN10(a));
    		error(['Need both Be-10 concentration and uncertainty - line ' int2str(a)]);
    end
end


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
    if all_isN26(a);
        if (strcmp(all_al_std_name(a),'KNSTD'))
            sample.N26 = all_N26(a).*consts.al_stds_cfs(1);
            sample.delN26 = all_delN26(a).*consts.al_stds_cfs(1);
        elseif (strcmp(all_al_std_name(a),'ZAL94'))
            sample.N26 = all_N26(a).*consts.al_stds_cfs(2);
            sample.delN26 = all_delN26(a).*consts.al_stds_cfs(2);
        elseif (strcmp(all_al_std_name(a),'AL09'))
            sample.N26 = all_N26(a).*consts.al_stds_cfs(3);
            sample.delN26 = all_delN26(a).*consts.al_stds_cfs(3);
        elseif (strcmp(all_al_std_name(a),'ZAL94N'))
            sample.N26 = all_N26(a).*consts.al_stds_cfs(4);
            sample.delN26 = all_delN26(a).*consts.al_stds_cfs(4);
        elseif (strcmp(all_al_std_name(a),'SMAL11'))
            sample.N26 = all_N26(a).*consts.al_stds_cfs(5);
            sample.delN26 = all_delN26(a).*consts.al_stds_cfs(5);
        elseif (strcmp(all_al_std_name(a),'Z92-0222'))
            sample.N26 = all_N26(a).*consts.al_stds_cfs(6);
            sample.delN26 = all_delN26(a).*consts.al_stds_cfs(6);
        elseif (strcmp(all_al_std_name(a),'0'))
            sample.N26 = all_N26(a).*consts.al_stds_cfs(7);	
            sample.delN26 = all_delN26(a).*consts.al_stds_cfs(7);
        end
     end
    
    if all_isN10(a);
        if (strcmp(all_be_std_name(a),'07KNSTD'))
            sample.N10 = all_N10(a).*consts.be_stds_cfs(1);
            sample.delN10 = all_delN10(a).*consts.be_stds_cfs(1);
        elseif (strcmp(all_be_std_name(a),'KNSTD'))
            sample.N10 = all_N10(a).*consts.be_stds_cfs(2);
            sample.delN10 = all_delN10(a).*consts.be_stds_cfs(2);
        elseif (strcmp(all_be_std_name(a),'NIST_Certified'))
            sample.N10 = all_N10(a).*consts.be_stds_cfs(3);
            sample.delN10 = all_delN10(a).*consts.be_stds_cfs(3);
        elseif (strcmp(all_be_std_name(a),'LLNL31000'))
            sample.N10 = all_N10(a).*consts.be_stds_cfs(4);
            sample.delN10 = all_delN10(a).*consts.be_stds_cfs(4);
        elseif (strcmp(all_be_std_name(a),'LLNL10000'))
            sample.N10 = all_N10(a).*consts.be_stds_cfs(5);
            sample.delN10 = all_delN10(a).*consts.be_stds_cfs(5);
        elseif (strcmp(all_be_std_name(a),'LLNL3000'))
            sample.N10 = all_N10(a).*consts.be_stds_cfs(6);
            sample.delN10 = all_delN10(a).*consts.be_stds_cfs(6);
        elseif (strcmp(all_be_std_name(a),'LLNL1000'))
            sample.N10 = all_N10(a).*consts.be_stds_cfs(7);
            sample.delN10 = all_delN10(a).*consts.be_stds_cfs(7);
        elseif (strcmp(all_be_std_name(a),'LLNL300'))
            sample.N10 = all_N10(a).*consts.be_stds_cfs(8);
            sample.delN10 = all_delN10(a).*consts.be_stds_cfs(8);
        elseif (strcmp(all_be_std_name(a),'NIST_30000'))
            sample.N10 = all_N10(a).*consts.be_stds_cfs(9);
            sample.delN10 = all_delN10(a).*consts.be_stds_cfs(9);
        elseif (strcmp(all_be_std_name(a),'NIST_30200'))
            sample.N10 = all_N10(a).*consts.be_stds_cfs(10);
            sample.delN10 = all_delN10(a).*consts.be_stds_cfs(10);
        elseif (strcmp(all_be_std_name(a),'NIST_30300'))
            sample.N10 = all_N10(a).*consts.be_stds_cfs(11);
            sample.delN10 = all_delN10(a).*consts.be_stds_cfs(11);
        elseif (strcmp(all_be_std_name(a),'NIST_30600'))
            sample.N10 = all_N10(a).*consts.be_stds_cfs(12);
            sample.delN10 = all_delN10(a).*consts.be_stds_cfs(12);
        elseif (strcmp(all_be_std_name(a),'NIST_27900'))
            sample.N10 = all_N10(a).*consts.be_stds_cfs(13);
            sample.delN10 = all_delN10(a).*consts.be_stds_cfs(13);
        elseif (strcmp(all_be_std_name(a),'S555'))
            sample.N10 = all_N10(a).*consts.be_stds_cfs(14);
            sample.delN10 = all_delN10(a).*consts.be_stds_cfs(14);
        elseif (strcmp(all_be_std_name(a),'S2007'))
            sample.N10 = all_N10(a).*consts.be_stds_cfs(15);
            sample.delN10 = all_delN10(a).*consts.be_stds_cfs(15);
        elseif (strcmp(all_be_std_name(a),'BEST433'))
            sample.N10 = all_N10(a).*consts.be_stds_cfs(16);
            sample.delN10 = all_delN10(a).*consts.be_stds_cfs(16);
        elseif (strcmp(all_be_std_name(a),'BEST433N'))
            sample.N10 = all_N10(a).*consts.be_stds_cfs(17);
            sample.delN10 = all_delN10(a).*consts.be_stds_cfs(17);
        elseif (strcmp(all_be_std_name(a),'S555N'))
            sample.N10 = all_N10(a).*consts.be_stds_cfs(18);
            sample.delN10 = all_delN10(a).*consts.be_stds_cfs(18);
        elseif (strcmp(all_be_std_name(a),'S2007N'))
            sample.N10 = all_N10(a).*consts.be_stds_cfs(19);
            sample.delN10 = all_delN10(a).*consts.be_stds_cfs(19);

        end
    end
    
%% Geomag and Spectra and Age Calculations

    if (all_isN26(a))
		nuclide = 26;
        disp(strcat('26Al: Calculating Geomagnetic Scaling and Cosmic-Ray Spectra, Sample_',num2str(a)));
        geomagAl = ScalingLSD(sample,consts,nuclide);
    end
    if (all_isN10(a)); 
        nuclide = 10;
        disp(strcat('10Be: Calculating Geomagnetic Scaling and Cosmic-Ray Spectra, Sample_',num2str(a)));
        geomagBe = ScalingLSD(sample,consts,nuclide);
    end
%%	
	
	% sort the results that will appear in multiple-sample output;
    
    sfa = ['LS';'LD'];
    
	if(all_isN26(a))
        t26 = geomagAl.tv;
        for b = 1:2
            SF26_LS(a,:) = geomagAl.SF_LS;
            SF26_LD(a,:) = geomagAl.SF_LD;
        end
    end
    
	if(all_isN10(a))
        t10 = geomagBe.tv;
        for b = 1:2
            SF10_LS(a,:) = geomagBe.SF_LS;
            SF10_LD(a,:) = geomagBe.SF_LD;
        end
    end	
end % End of main calculation loop -- 

