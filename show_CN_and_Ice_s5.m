
% This script parameterizes the glacial history of a bedrock sample wrt.
% ice cover duration, thickness, and subglacial erosion. It then calls a 
% subfunction 'forward_CN_bedrock.m' which calculates the cosmogenic 
% nuclide inventory (10Be-26Al-14C) over time based on these parameters. 
% The script produces a plot of ice-thickness change and cosmogenic nuclide 
% build-up as a function of time.

% Developed by Jane Lund Andersen, Aarhus University (jane.lund@geo.au.dk),
% and Allie Koester, Purdue University (kostea@purdue.edu), 2021-23

clear, close all
set(groot','defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');

load RiukoProduction.mat consts samples %created with 'compile_production.m'

%% a few variables
dt = 1; %time step, keep at 1 kyr
Esubgla = 0; %0.01cm/yr = 0.1 mm yr-1 (Dahl et al., 2003)
Tstart = 20; %This sets the time-range the data are plotted over (ka BP), but is not related to the model
xlmax = 12; %This sets the xlim max value (ka BP)

%% initiate figures and plot sample data
figure(1) % sample 5
t = tiledlayout(3,1,'TileSpacing','compact');

ax1 = nexttile(1); %14C
sIDs=5; %sample index's
tname=['Sample: ' char(samples{sIDs(1)}.name)];
title(tname,'interpreter','latex','FontSize',16)
colororder([.1 .1 .1; .3 .4 1]) % colororder({'k','b'})
yyaxis left
hold on
cols={[.5 .2 .2] [.2 .2 .5]};
for i=1:length(sIDs) %sample index's
    patch([0 Tstart Tstart 0],[samples{sIDs(i)}.N14-samples{sIDs(i)}.dN14.*2 ...
        samples{sIDs(i)}.N14-samples{sIDs(i)}.dN14.*2 samples{sIDs(i)}.N14+samples{sIDs(i)}.dN14.*2. ...
        samples{sIDs(i)}.N14+samples{sIDs(i)}.dN14.*2 ],cols{i},'EdgeColor',cols{i},'FaceAlpha',.5)
        text(5.5,samples{sIDs(i)}.N14+3e4,samples{sIDs(i)}.name,'Color',cols{i})
end
xlim([0 xlmax]), ylim([0 3e5])
set(gca,'FontSize',12)
ylabel("C-14 (at g$^{-1}$)",'fontsize',16)
text(.3,2.8e5,'a','fontsize',20)
yyaxis right
set(gca,'FontSize',12)
ylabel("Ice thickness (m)",'FontSize',16)

ax2 = nexttile(2); % 10Be
hold on
cols={[.5 .2 .2] [.2 .2 .5]};
for i=1:length(sIDs) %sample index's
    patch([0 Tstart Tstart 0],[samples{sIDs(i)}.N10-samples{sIDs(i)}.dN10.*2 ...
        samples{sIDs(i)}.N10-samples{sIDs(i)}.dN10.*2 samples{sIDs(i)}.N10+samples{sIDs(i)}.dN10.*2. ...
        samples{sIDs(i)}.N10+samples{sIDs(i)}.dN10.*2 ],cols{i},'EdgeColor',cols{i},'FaceAlpha',.5)
        text(5.5,samples{sIDs(i)}.N10+2e4,samples{sIDs(i)}.name,'Color',cols{i})
end
xlim([0 xlmax]), ylim([0 2e5]) 
set(gca,'FontSize',12)
ylabel("Be-10 (at g$^{-1}$)",'FontSize',16)
text(.3,1.8e5,'b','fontsize',20)

ax3 = nexttile(3); %26Al
hold on
cols={[.5 .2 .2] [.2 .2 .5]};
for i=1:length(sIDs) %sample index's
    patch([0 Tstart Tstart 0],[samples{sIDs(i)}.N26-samples{sIDs(i)}.dN26.*2 ...
        samples{sIDs(i)}.N26-samples{sIDs(i)}.dN26.*2 samples{sIDs(i)}.N26+samples{sIDs(i)}.dN26.*2. ...
        samples{sIDs(i)}.N26+samples{sIDs(i)}.dN26.*2 ],cols{i},'EdgeColor',cols{i},'FaceAlpha',.5)
        text(5.5,samples{sIDs(i)}.N26+1e5,samples{sIDs(i)}.name,'Color',cols{i})
end
xlim([0 xlmax]), ylim([0 1e6])
set(gca,'FontSize',12)
ylabel("Al-26 (at g$^{-1}$)",'FontSize',16)
text(.3,9e5,'c','fontsize',20)

xlabel(t,"Time (ka BP)",'fontsize',16,'interpreter','latex')

%% Define ice-cover scenarios and calculate nuclide build-up
method=3; %three different methods implemented, choose 1, 2, or 3 to try them out
switch method
    case 1 % Method #1:choose a pre-defined scenario from 'define_ice_history.m'
        cs=2; % 1=Finse re-advance, 2=complete ice-free at 8.5ka, 3=ice-free at 5ka (LOI), 4=MIS3 exposure?
        [ice_hist,ts] = define_ice_history(cs,dt);

        % Calculate cosmogenic nuclide inventories over time, note calculated with 
        % production profile from first sample only, but they are very similar
        [b14C,b10Be,b26Al] = forward_CN_bedrock(ts,ice_hist,Esubgla,samples{sIDs(1)},consts);
        axes(ax1), plot(ts/1e3,b14C,'k','LineWidth',2);
        yyaxis right
        plot(ts/1e3,(ice_hist./100),'LineWidth',2)
        plot(ax2,ts/1e3,b10Be,'k','LineWidth',2);
        plot(ax3,ts/1e3,b26Al,'k','LineWidth',2);

    case 2 % Method #2: hardcode some values in directly below for quick tests
        ice_times=[20000 10000 8500 8000 7500 2500 105 55 37 0]; %time fixpoints (years prior to 2015)
        ice_cover=[200 0 0 40 0 0 35 25 19 0]*100; %Ice thickness at times in ice_times (cm)
        ts = (ice_times(1)-1):-dt:0; %time vector for calculations
        ice_hist=interp1(ice_times,ice_cover,ts); %interpolate ice-thickness at times in time vector

        % Calculate cosmogenic nuclide inventories over time, note calculated with 
        % production profile from first sample only, but they are very similar
        [b14C,b10Be,b26Al] = forward_CN_bedrock(ts,ice_hist,Esubgla,samples{sIDs(1)},consts);
        axes(ax1), plot(ts/1e3,b14C,'k','LineWidth',2);
        yyaxis right
        plot(ts/1e3,(ice_hist./100),'LineWidth',2)
        plot(ax2,ts/1e3,b10Be,'k','LineWidth',2);
        plot(ax3,ts/1e3,b26Al,'k','LineWidth',2);

    case 3 % Method #3: Loop over one variable and plot to examine effect
        LIAc=[.5 1 2 3]*1e3; %Beginning of full exposure during Holocene thermal maximum
        Lstyles={'-','--','-.',':'};
        for i=1:length(LIAc)
            ice_times=[20000 9500 LIAc(i)+2e2 LIAc(i) 105 0]; %time fixpoints (years prior to 2015)
            ice_cover=[200 0 0 30 0 0]*100; %Ice thickness at times in ice_times (cm) 
            ts = (ice_times(1)-1):-dt:0; %time vector for calculations
            ice_hist=interp1(ice_times,ice_cover,ts); %interpolate ice-thickness at times in time vector

            % Calculate cosmogenic nuclide inventories over time, note calculated with 
            % production profile from first sample only, but they are very similar
            [b14C,b10Be,b26Al] = forward_CN_bedrock(ts,ice_hist,Esubgla,samples{sIDs(1)},consts);
            axes(ax1), yyaxis left
            plot(ts/1e3,b14C,'k','LineWidth',1.5,'Linestyle',Lstyles{i});
            yyaxis right
            plot(ts/1e3,(ice_hist./100),'LineWidth',2,'Linestyle',Lstyles{i})
            plot(ax2,ts/1e3,b10Be,'k','LineWidth',2,'Linestyle',Lstyles{i});
            plot(ax3,ts/1e3,b26Al,'k','LineWidth',2,'Linestyle',Lstyles{i});
        end
end

set(gcf,'units','normalized','position',[.2,.3,.4,.6]);

%%
set(groot','defaulttextinterpreter','default');
set(groot, 'defaultAxesTickLabelInterpreter','default'); 
set(groot, 'defaultLegendInterpreter','default');