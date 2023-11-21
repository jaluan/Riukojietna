% Balculator_be_al_LSD

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

% file = input('Please enter the name of the sample data file','s');
file='riuko_BeAlfin.txt'; %temporary change by JLA
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

% make_constsPavonTgt;
load consts_LSDPavonTgt;
% make_consts_LSDLal;
% load consts_LSDLal;


num_samples = length(all_lat);

% determine which nuclides were submitted --
for a = 1:num_samples	
	if all_N26(a) ~= 0;
		all_isN26(a) = 1; 
    else
		all_isN26(a) = 0; 
    end

	if all_delN26(a) ~= 0;
		all_isdelN26(a) = 1; 
    else
		all_isdelN26(a) = 0; 
    end
	
	if all_N10(a) ~= 0;
		all_isN10(a) = 1;
    else
		all_isN10(a) = 0;
    end

	if all_delN10(a) ~= 0;
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
        geomag = ScalingLSDLal(sample,consts,nuclide);
        al_results = get_age_LSDLal(sample,consts,26,geomag,a);
    end
    if (all_isN10(a)); 
        nuclide = 10;
        disp(strcat('10Be: Calculating Geomagnetic Scaling and Cosmic-Ray Spectra, Sample_',num2str(a)));
        geomag = ScalingLSDLal(sample,consts,nuclide);
        be_results = get_age_LSDLal(sample,consts,10,geomag,a); 
    end
%%	
	% if both nuclides, get the ratios and uncertainty therein;

	clear drdN26 drdN10;
	if (all_isN26(a) && all_isN10(a));
    		r2610(a) = sample.N26./sample.N10;
    		drdN26 = 1./sample.N10;
    		drdN10 = -sample.N26./(sample.N10.^2);
    		delR(a) = sqrt( (sample.delN10.*drdN10).^2 + (sample.delN26.*drdN26).^2 );
    end
	
	
	% sort the results that will appear in multiple-sample output;
    
    sfa = ['LS';'Lm';'St'];
    
	if(all_isN26(a));
        % Non-SF-dependent
        thick_sf(a) = al_results.thick_sf;
        P26_mu_St(a) = al_results.P_mu_St;
        % Scalar production rate from Stone/Lal
        P26_St(a) = al_results.P_St;
		% SF-dependent
        for b = 1:3;
            eval(['t26_' sfa(b,:) '(a) = al_results.t_' sfa(b,:) ';']);
            eval(['FSF26_' sfa(b,:) '(a) = al_results.FSF_' sfa(b,:) ';']);
            eval(['delt26_int_' sfa(b,:) '(a) = al_results.delt_int_' sfa(b,:) ';']);
            eval(['delt26_ext_' sfa(b,:) '(a) = al_results.delt_ext_' sfa(b,:) ';']);
        end;
        % Add output flags to dstring
        if ~isempty(al_results.flags);
            dstring = [dstring ' ' al_results.flags '<br>'];
        end
    end
    
	if(all_isN10(a));
		% Non-SF-dependent
        thick_sf(a) = be_results.thick_sf;
        P10_mu_St(a) = be_results.P_mu_St;
        % Scalar production rate from Stone/Lal
        P10_St(a) = be_results.P_St;
		% SF-dependent
        for b = 1:3;
            eval(['t10_' sfa(b,:) '(a) = be_results.t_' sfa(b,:) ';']);
            eval(['FSF10_' sfa(b,:) '(a) = be_results.FSF_' sfa(b,:) ';']);
            eval(['delt10_int_' sfa(b,:) '(a) = be_results.delt_int_' sfa(b,:) ';']);
            eval(['delt10_ext_' sfa(b,:) '(a) = be_results.delt_ext_' sfa(b,:) ';']);
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
if (all_isN26(a));
    outstr.main_version = al_results.main_version;
%     outstr.muon_version = al_results.muon_version;
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

for a = 1:num_samples;
	if (all_isN10(a));
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
        temp = [temp sprintf('%8.3f\t',P10_mu_St(a))];
        outstr.results_10_ntd = [outstr.results_10_ntd temp];
        fprintf(fid1, '%s\n', temp);
	else 
		% if no Be-10 data, write a table line anyway
    	outstr.results_10_ntd = [outstr.results_10_ntd all_sample_name{a}];
        fprintf(fid1, '%s\n', all_sample_name{a});
	end;
end;
fclose(fid1);

% Al-26 results, Lal/Stone production rate scaling.

outstr.results_26_ntd = '';

fid2 = fopen('results_26_ntd.txt','w');
line1 = 'sample_name\tthick_sf\tall_shielding\tt26_St\tdelt26_int_St\tdelt26_ext_St\tP26_St\tP26_mu\n';
fprintf(fid2 ,line1);

for a = 1:num_samples;
	if (all_isN26(a));
		% if Al-26 data, write a full line
        % Line is sample_name - t26_St - delt26_int_St - delt26_ext_St -
        % thickSF - shielding - P26_sp - P26_mu
		temp = [all_sample_name{a}];
		temp = [temp sprintf('\t%8.4f\t',thick_sf(a))];
        temp = [temp sprintf('%8.4f\t',all_shielding(a))];
		temp = [temp sprintf('%8.0f\t',t26_St(a))];
		temp = [temp sprintf('%8.0f\t',delt26_int_St(a))];
		temp = [temp sprintf('%8.0f\t',delt26_ext_St(a))];
        temp = [temp sprintf('%8.2f\t',P26_St(a))];
		temp = [temp sprintf('%8.3f\t',P26_mu_St(a))];
        outstr.results_26_ntd = [outstr.results_26_ntd temp];
        fprintf(fid2, '%s\n', temp);
	else 
		% if no Al-26 data, write a table line anyway
    		outstr.results_26_ntd = [outstr.results_26_ntd all_sample_name{a}];
	        fprintf(fid2, '%s\n', all_sample_name{a});
    end;
end;
fclose(fid2);

% Be-10 results, time-dependent scaling schemes

outstr.results_10_td = '';

fid3 = fopen('results_10_td.txt','w');
line1 = 'sample_name\tt10LS\tdelt10_ext_LS\tSF10_eff_LS\tt10_Lm\tdelt10_ext_Lm\tSF10_eff_Lm\n';
fprintf(fid3 ,line1);
        
for a = 1:num_samples;
	if (all_isN10(a));
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
    end;
end;
fclose(fid3);

% Al-26 results, time-dependent scaling schemes

outstr.results_26_td = '';

fid4 = fopen('results_26_td.txt','w');
line1 = 'sample_name\tt26LS\tdelt26_ext_LS\tSF26_eff_LS\tt26_Lm\tdelt26_ext_Lm\tSF26_eff_Lm\n';
fprintf(fid4 ,line1);

for a = 1:num_samples;
	if (all_isN26(a));
		% if Al-26 data, write a full line
        % Line is sample_name - t26_De - delt26_ext_De - t26_Du -
        % delt26_ext_Du - t26_Li - delt26_ext_Li
		temp = [all_sample_name{a}];
        temp = [temp sprintf('\t%8.0f\t',t26_LS(a))];
        temp = [temp sprintf('%8.0f\t',delt26_ext_LS(a))];
        temp = [temp sprintf('%8.4f\t',FSF26_LS(a))];
        temp = [temp sprintf('%8.0f\t',t26_Lm(a))];
        temp = [temp sprintf('%8.0f\t',delt26_ext_Lm(a))];
        temp = [temp sprintf('%8.4f\t',FSF26_Lm(a))];
		outstr.results_26_td = [outstr.results_26_td temp];
        fprintf(fid4, '%s\n', temp);
    else 
		% if no Al-26 data, write a table line anyway
    		outstr.results_26_td = [outstr.results_26_td all_sample_name{a}];
		    fprintf(fid4, '%s\n', all_sample_name{a});
    end;
end;
fclose(fid4);

% 26/10 ratio and uncertainty

outstr.results_R = '';

fid5 = fopen('results_ratio.txt','w');
line1 = 'sample_name\tr2610\t+/-\tdelR\n';
fprintf(fid5 ,line1);

for a = 1:num_samples;
	if (all_isN10(a) && all_isN26(a));
    		temp = [all_sample_name{a}];
		temp = [temp sprintf('\t%4.2f\t',r2610(a)) ' +/- ' sprintf('\t%4.2f',delR(a))];
        fprintf(fid5, '%s\n', temp);
    else
    		temp = [all_sample_name{a}];
            fprintf(fid5, '%s\n', all_sample_name{a});
    end
	outstr.results_R = [outstr.results_R temp];
end;
fclose(fid5);

retstr = outstr;

CD = pwd;
disp(['All files saved to ' CD]) 
disp(['Results files are "results_10_ntd", "results_10_td", "results_26_ntd", "results_26_td", "and results_ratio"'])