%Balculator_c_bcLSDLal

%stone_ager -- Script that performs exposure calculations, 
%similar to that on the web. Data should be saved as a text file using the 
%formatting required by the webcalc. The script does not perform the same 
%error checks that the webcalc performs, so be a good person and follow 
%all the rules. The ages and data are saved in five files, two for the Be 
%data (time dependent and non-time dependent) and the same for C. A fifth 
%file is created with ratio information. All files are saved in the current
%Matlab directory. No plotting is performed (may be added later). 
%
%
%Written by Brent Goehring, 2007
%Lamont-Doherty Earth Observatory
%The script relies heavily on the CRONUS-Earth web calc toolbox written by 
%Greg Balco, Unversity of Washington  and willnot run with out all scripts. 
%Does not perform erosion calculations.

%Load the data to be used. For consistency sake, use the same format that
%Balco requires for the web calc. The data set should be saved as a txt
%file in a directory Matlab can see.

file = input('Please enter the name of the sample data file','s');
FID = fopen(file);
data = textscan(FID,'%s %n %n %n %s %n %n %n %n %n %n %n %n %s');
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
all_N14 = data{10};
all_delN14 = data{11}; 
all_N10 = data{12};
all_delN10 = data{13}; 
all_be_std_name = data{14};

%Make the constants file.
%make_constsPavonTgt;
%load consts_LSDPavonTgt;
% make_consts_LSDLal;
load consts_LSDPavonTgt_v2.mat; %has updated P_ref_LS values
%load consts_LSDLal.mat; %has updated P_Ref_LS values
%load('C:\Users\Allie Jo\Documents\MATLAB\Cronus_Balculator_Depthprofmodel\consts_LSDPavonTgt.mat')
num_samples = length(all_lat);

% determine which nuclides were submitted --
for a = 1:num_samples	
	if all_N14(a) ~= 0;
		all_isN14(a) = 1; 
        nuclide = 14;
    else
		all_isN14(a) = 0; 
    end

	if all_delN14(a) ~= 0;
		all_isdelN14(a) = 1; 
    else
		all_isdelN14(a) = 0; 
    end
	
	if all_N10(a) ~= 0;
		all_isN10(a) = 1;
        nuclide = 10;
    else
		all_isN10(a) = 0;
    end

	if all_delN10(a) ~= 0;
		all_isdelN10(a) = 1; 
    else
		all_isdelN10(a) = 0; 
    end
	
	% catch mismatches;
	
	if (~all_isN14(a) && ~all_isN10(a))
   		error(['Need either C-14 or Be-10 concentration - line ' int2str(a)]);
	elseif (all_isN14(a) && ~all_isdelN14(a)) || (~all_isN14(a) && all_isdelN14(a));
    		error(['Need both C-14 concentration and uncertainty - line ' int2str(a)]);
	elseif (all_isN10(a) && ~all_isdelN10(a)) || (~all_isN10(a) && all_isdelN10(a));
    		error(['Need both Be-10 concentration and uncertainty - line ' int2str(a)]);
    end
end

%Determine production rates
%ICN = input('Where the 10Be samples measured relative to the Nishiizumi et al., 2007 ICN standard [y/n]?', 's');


for a = 1:num_samples
%     sample.sample_name{a} = all_sample_name{a};
    sample.sample_name = all_sample_name{a};
    sample.lat = all_lat(a);
    sample.long = all_long(a);
    %sample.elv = all_elv(i);
    %sample.pressure = all_pressure(i);
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
    if all_isN14(a);
		sample.N14 = all_N14(a);
		sample.delN14 = all_delN14(a);
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

    
%% Geomag and Spectra Calculations

% 	disp(strcat('Calculating Geomagnetic Scaling and Cosmic-Ray Spectra, Sample_',num2str(a)));
%     % geomag = Geomag(sample,consts);
%     geomag = GeomagSX(sample,consts, nuclide);
%     % geomag = GeomagCRONUSOrigGAD(sample,consts);
% %%

% Get the exposure ages;

     if (all_isN14(a))
		nuclide = 14;
        disp(strcat('14C: Calculating Geomagnetic Scaling and Cosmic-Ray Spectra, Sample_',num2str(a)));
        geomag = ScalingLSDLal(sample,consts,nuclide);
        c_results = get_age_LSDLal(sample,consts,14,geomag,a);
    end
    if (all_isN10(a))
        nuclide = 10;
        disp(strcat('10Be: Calculating Geomagnetic Scaling and Cosmic-Ray Spectra, Sample_',num2str(a)));
        geomag = ScalingLSDLal(sample,consts,nuclide);
        be_results = get_age_LSDLal(sample,consts,10,geomag,a); 
    end
	
	% if both nuclides, get the ratios and uncertainty therein;

	clear drdN14 drdN10;
	if (all_isN14(a) && all_isN10(a))
    		r1410(a) = sample.N14./sample.N10;
    		drdN14 = 1./sample.N10;
    		drdN10 = -sample.N14./(sample.N10.^2);
    		delR(a) = sqrt( (sample.delN10.*drdN10).^2 + (sample.delN14.*drdN14).^2 );
    end
	
	
	% sort the results that will appear in multiple-sample output;
        
    sfa = ['LS';'Lm';'St'];
    
	if(all_isN14(a))
        % Non-SF-dependent
        thick_sf(a) = c_results.thick_sf;
        P14_mu(a) = c_results.P_mu_St;
        % Scalar production rate from Stone/Lal
        P14_St(a) = c_results.P_St;
		% SF-dependent
        for b = 1:3
            eval(['t14_' sfa(b,:) '(a) = c_results.t_' sfa(b,:) ';']);
            eval(['FSF14_' sfa(b,:) '(a) = c_results.FSF_' sfa(b,:) ';']);
            eval(['delt14_int_' sfa(b,:) '(a) = c_results.delt_int_' sfa(b,:) ';']);
            eval(['delt14_ext_' sfa(b,:) '(a) = c_results.delt_ext_' sfa(b,:) ';']);
            eval(['P14_fast_' sfa(b,:) '(a) = c_results.P_fast_' sfa(b,:) ';']); %added by AJK
            eval(['P14_neg_' sfa(b,:) '(a) = c_results.P_neg_' sfa(b,:) ';']); %added by AJK
        end;
        % Add output flags to dstring
        if ~isempty(c_results.flags)
            dstring = [dstring ' ' c_results.flags '<br>'];
        end
    end    
    
	if(all_isN10(a))
		% Non-SF-dependent
        thick_sf(a) = be_results.thick_sf;
        P10_mu(a) = be_results.P_mu_St;
        % Scalar production rate from Stone/Lal
        P10_St(a) = be_results.P_St;
		% SF-dependent
        for b = 1:3
            eval(['t10_' sfa(b,:) '(a) = be_results.t_' sfa(b,:) ';']);
            eval(['FSF10_' sfa(b,:) '(a) = be_results.FSF_' sfa(b,:) ';']);
            eval(['delt10_int_' sfa(b,:) '(a) = be_results.delt_int_' sfa(b,:) ';']);
            eval(['delt10_ext_' sfa(b,:) '(a) = be_results.delt_ext_' sfa(b,:) ';']);
            eval(['P10_fast_' sfa(b,:) '(a) = be_results.P_fast_' sfa(b,:) ';']); %added by AJK
            eval(['P10_neg_' sfa(b,:) '(a) = be_results.P_neg_' sfa(b,:) ';']); %added by AJK
        end
        % Add output flags to dstring
        if ~isempty(be_results.flags);
            dstring = [dstring ' ' be_results.flags '<br>'];
        end
    end
	
	
% 	clear sample;
	
end % End of main calculation loop -- 

% start output string extraction...

% A. Things that are the same for all samples and can be extracted from the most 
% recent results set:

%outstr.wrapper_version = ver;
outstr.consts_version = consts.version;
if (all_isN14(a))
    outstr.main_version = c_results.main_version;
%     outstr.muon_version = c_results.muon_version;
else
    outstr.main_version = be_results.main_version;
%     outstr.muon_version = be_results.muon_version;
end
	
%numsamples = length(all_lat);

% B. Strings for exposure-age reporting. 

% Correction factors, Be-10 results, Lal/Stone production rate scaling

outstr.results_10_ntd = '';

fid1 = fopen('results_10_ntd.txt','w');
line1 = 'sample_name\tthickSF\tshielding\tt10_St\tdelt10_int_St\tdelt10_ext_St\tP10_St\tP10_mu\n';
fprintf(fid1 ,line1);

for a = 1:num_samples
	if (all_isN10(a))
		% if Be-10 data, write a full line
        % Line is sample_name - t10_St - delt10_int_St - delt10_ext_St -
        % thickSF - shielding - P10_St
		temp = [all_sample_name{a}];
		temp = [temp sprintf('\t%8.4f\t',thick_sf(a))];
        temp = [temp sprintf('%8.4f\t',all_shielding(a))];
        temp = [temp sprintf('%8.0f\t',t10_St(a))];
		temp = [temp sprintf('%8.0f\t',delt10_int_St(a))];
        temp = [temp sprintf('%8.0f\t',delt10_ext_St(a))];
        temp = [temp sprintf('%8.2f\t',P10_St(a))];
        temp = [temp sprintf('%8.3f\t',P10_mu(a))];
        outstr.results_10_ntd = [outstr.results_10_ntd temp];
        fprintf(fid1, '%s\n', temp);
	else 
		% if no Be-10 data, write a table line anyway
    	outstr.results_10_ntd = [outstr.results_10_ntd all_sample_name{a}];
        fprintf(fid1, '%s\n', all_sample_name{a});
    end
end
fclose(fid1);

% C-14 results, Lal/Stone production rate scaling.

outstr.results_14_ntd = '';

fid2 = fopen('results_14_ntd.txt','w');
line1 = 'sample_name\tthick_sf\tall_shielding\tt14_St\tdelt14_int_St\tdelt14_ext_St\tP14_St\tP14_mu\n';
fprintf(fid2 ,line1);

for a = 1:num_samples
	if (all_isN14(a))
		% if C-14 data, write a full line
        % Line is sample_name - t14_St - delt14_int_St - delt14_ext_St -
        % thickSF - shielding - P14_sp - P14_mu
		temp = [all_sample_name{a}];
		temp = [temp sprintf('\t%8.4f\t',thick_sf(a))];
        temp = [temp sprintf('%8.4f\t',all_shielding(a))];
		temp = [temp sprintf('%8.0f\t',t14_St(a))];
		temp = [temp sprintf('%8.0f\t',delt14_int_St(a))];
		temp = [temp sprintf('%8.0f\t',delt14_ext_St(a))];
        temp = [temp sprintf('%8.2f\t',P14_St(a))];
		temp = [temp sprintf('%8.3f\t',P14_mu(a))];
        outstr.results_14_ntd = [outstr.results_14_ntd temp];
        fprintf(fid2, '%s\n', temp);
	else 
		% if no C-14 data, write a table line anyway
    		outstr.results_14_ntd = [outstr.results_14_ntd all_sample_name{a}];
	        fprintf(fid2, '%s\n', all_sample_name{a});
    end
end
fclose(fid2);

% Be-10 results, time-dependent scaling schemes

outstr.results_10_td = '';

fid3 = fopen('results_10_td.txt','w');
line1 = 'sample_name\tt10LS\tdelt10_ext_LS\tSF10_eff_LS\tt10_Lm\tdelt10_ext_Lm\tSF10_eff_Lm\n';
fprintf(fid3 ,line1);
        
for a = 1:num_samples
	if (all_isN10(a))
		% if Be-10 data, write a full line
        % Line is sample_name - t10_De - delt10_ext_De - t10_Du -
        % delt10_ext_Du - t10_Li - delt10_ext_Li
		temp = [all_sample_name{a}];
        temp = [temp sprintf('\t%8.0f\t',t10_LS(a))];
        temp = [temp sprintf('%8.0f\t',delt10_ext_LS(a))];
        temp = [temp sprintf('%8.4f\t',FSF10_LS(a))];
        temp = [temp sprintf('%8.0f\t',t10_Lm(a))];
        temp = [temp sprintf('%8.0f\t',delt10_ext_Lm(a))];
        temp = [temp sprintf('%8.4f\t',FSF10_Lm(a))];
		outstr.results_10_td = [outstr.results_10_td temp];
        fprintf(fid3, '%s\n', temp);
	else 
		% if no Be-10 data, write a table line anyway
    		outstr.results_10_td = [outstr.results_10_td all_sample_name{a}];
		    fprintf(fid3, '%s\n', all_sample_name{a});
    end
end
fclose(fid3);

% C-14 results, time-dependent scaling schemes

outstr.results_14_td = '';

fid4 = fopen('results_14_td.txt','w');
line1 = 'sample_name\tt14LS\tdelt14_int_LS\tdelt14_ext_LS\tSF14_eff_LS\tt14_Lm\tdelt14_ext_Lm\tSF14_eff_Lm\n';
fprintf(fid4 ,line1);

for a = 1:num_samples
	if (all_isN14(a))
		% if C-14 data, write a full line
        % Line is sample_name - t14_De - delt14_ext_De - t14_Du -
        % delt14_ext_Du - t14_Li - delt14_ext_Li
		temp = [all_sample_name{a}];
        temp = [temp sprintf('\t%8.0f\t',t14_LS(a))];
        temp = [temp sprintf('%8.0f\t',delt14_int_LS(a))];
        temp = [temp sprintf('%8.0f\t',delt14_ext_LS(a))];
        temp = [temp sprintf('%8.4f\t',FSF14_LS(a))];
        temp = [temp sprintf('%8.0f\t',t14_Lm(a))];
        temp = [temp sprintf('%8.0f\t',delt14_ext_Lm(a))];
        temp = [temp sprintf('%8.4f\t',FSF14_Lm(a))];
		outstr.results_14_td = [outstr.results_14_td temp];
        fprintf(fid4, '%s\n', temp);
    else 
		% if no C-14 data, write a table line anyway
    		outstr.results_14_td = [results_14_td all_sample_name{a}];
		    fprintf(fid4, '%s\n', all_sample_name{a});
    end
end
fclose(fid4);

% 14/10 ratio and uncertainty

outstr.results_R = '';

fid5 = fopen('results_ratio.txt','w');
line1 = 'sample_name\tr1410\t+/-\tdelR\n';
fprintf(fid5 ,line1);

for a = 1:num_samples
	if (all_isN10(a) && all_isN14(a))
    		temp = [all_sample_name{a}];
		temp = [temp sprintf('%4.2f\t',r1410(a)) ' +/- ' sprintf('\t%4.2f',delR(a))];
        fprintf(fid5, '%s\n', temp);
    else
    		temp = [all_sample_name{a}];
            fprintf(fid5, '%s\n', all_sample_name{a});
    end
	outstr.results_R = [outstr.results_R temp];
end
fclose(fid5);

retstr = outstr;

CD = pwd;
disp(['All files saved to ' CD]) 
disp(['Results files are "results_10_ntd", "results_10_td", "results_14_ntd", "results_14_td", "and results_ratio"'])