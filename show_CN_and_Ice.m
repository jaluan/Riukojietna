
% This script parameterizes the glacial history of a bedrock sample wrt.
% ice cover duration, thickness, and subglacial erosion. It then calls a 
% subfunction 'forward_CN_bedrock.m' which calculates the cosmogenic 
% nuclide inventory (10Be-26Al-14C) over time based on these parameters. 
% The script produces a plot of ice-thickness change and cosmogenic nuclide 
% build-up as a function of time.

% Developed by Jane Lund Andersen, Aarhus University (jane.lund@geo.au.dk), 
% and Allie Koester, Purdue University (koestea@purdue.edu), 2021-23

clear, close all
set(groot','defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');

load RiukoProduction.mat consts samples %created with 'compile_production.m'
% addpath('Functions','Functions/Spectra/')

%% a few variables
dt = 1; %time step, keep at 1 year
Esubgla = 0; %No subglacial erosion
Esubgla1 = 0.008; %Subglacial erosion = 0.01cm/yr = 0.1 mm yr-1 (Hallet et al., 1996).
Tmax = 12; %Sets the max time shown on figures (ka BP) - does not control the model start point

%% initiate figures and plot sample data
figure(1) 
t = tiledlayout(3,2,'TileSpacing','compact');

ax1 = nexttile(1); %14C samples 1 and 2
sIDs=1:2; %sample index's
tname=['Riuko-' char(samples{sIDs(1)}.name) ' and ' char(samples{sIDs(2)}.name)];
title(tname,'interpreter','latex','FontSize',16)

colororder([.1 .1 .1; .3 .4 .9]) % colororder({'k','b'})
yyaxis left
hold on 
cols={[.5 .5 .5] [.2 .2 .2]}; %[.5 .2 .2] [.285 .496 .598] [.3 .3 .4]
for i=1:2 %sample index's
    patch([0 Tmax Tmax 0],[samples{i}.N14-samples{i}.dN14.*2 ...
        samples{i}.N14-samples{i}.dN14.*2 samples{i}.N14+samples{i}.dN14.*2. ...
        samples{i}.N14+samples{i}.dN14.*2 ],cols{i},'EdgeColor',cols{i},'FaceAlpha',.5)
    if i==1, text(5.5,samples{i}.N14-3e4,samples{i}.name,'Color',cols{i})
    else, text(5.5,samples{i}.N14+3e4,samples{i}.name,'Color',cols{i})
    end
end
xlim([0 Tmax]), ylim([0 3e5])
set(gca,'FontSize',14,'XTickLabel','')
ylabel("$^{14}$C (at g$^{-1}$)",'fontsize',16) %ylabel("C-14 (at g$^{-1}$)",'fontsize',16)
text(.3,2.8e5,'a','fontsize',20)
box on

ax2 = nexttile(3); %sample 1 and 2, 10Be
hold on
for i=1:2 %sample index's
    patch([0 Tmax Tmax 0],[samples{i}.N10-samples{i}.dN10.*2 ...
        samples{i}.N10-samples{i}.dN10.*2 samples{i}.N10+samples{i}.dN10.*2. ...
        samples{i}.N10+samples{i}.dN10.*2 ],cols{i},'EdgeColor',cols{i},'FaceAlpha',.5)
    if i==1, text(5.5,samples{i}.N10-2.5e4,samples{i}.name,'Color',cols{i})
    else, text(5.5,samples{i}.N10+2.5e4,samples{i}.name,'Color',cols{i})
    end
end
xlim([0 Tmax]), ylim([0 3e5]) 
set(gca,'FontSize',14,'XTickLabel','')
ylabel("$^{10}$Be (at g$^{-1}$)",'FontSize',16) % ylabel("Be-10 (at g$^{-1}$)",'FontSize',16)
text(.3,2.8e5,'c','fontsize',20)
box on

ax5 = nexttile(5); %sample 1 and 2, 26Al
hold on
for i=1:2 %sample index's
    patch([0 Tmax Tmax 0],[samples{i}.N26-samples{i}.dN26.*2 ...
        samples{i}.N26-samples{i}.dN26.*2 samples{i}.N26+samples{i}.dN26.*2. ...
        samples{i}.N26+samples{i}.dN26.*2 ],cols{i},'EdgeColor',cols{i},'FaceAlpha',.5)
    if i==1, text(5.5,samples{i}.N26-2.5e5,samples{i}.name,'Color',cols{i})
    else, text(5.5,samples{i}.N26+2.5e5,samples{i}.name,'Color',cols{i})
    end
end
xlim([0 Tmax]), ylim([0 2e6]) 
set(gca,'FontSize',14,'YTick',0:1e6:2e6)
ylabel("$^{26}$Al (at g$^{-1}$)",'FontSize',16) %ylabel("Al-26 (at g$^{-1}$)",'FontSize',16)
text(.3,1.8e6,'e','fontsize',20)
box on

ax3 = nexttile(2); %14C
sIDs=3:4; %sample index's
tname=['Riuko-' char(samples{sIDs(1)}.name) ' and ' char(samples{sIDs(2)}.name)];
title(tname,'interpreter','latex','FontSize',16)

colororder([.1 .1 .1; .3 .4 .9]) % colororder({'k','b'})
yyaxis left
hold on
cols={[.5 .5 .5] [.2 .2 .2]}; %{[.5 .2 .2] [.2 .2 .5]};
for i=1:length(sIDs) %sample index's
    patch([0 Tmax Tmax 0],[samples{sIDs(i)}.N14-samples{sIDs(i)}.dN14.*2 ...
        samples{sIDs(i)}.N14-samples{sIDs(i)}.dN14.*2 samples{sIDs(i)}.N14+samples{sIDs(i)}.dN14.*2. ...
        samples{sIDs(i)}.N14+samples{sIDs(i)}.dN14.*2 ],cols{i},'EdgeColor',cols{i},'FaceAlpha',.5)
    if i==2, text(6.4,samples{sIDs(i)}.N14-3e4,samples{sIDs(i)}.name,'Color',cols{i})
    else, text(6.4,samples{sIDs(i)}.N14+3e4,samples{sIDs(i)}.name,'Color',cols{i})
    end
end
xlim([0 Tmax]), ylim([0 3e5])
text(.3,2.7e5,'b','fontsize',20)
yyaxis right
set(gca,'FontSize',14,'XTickLabel','')
ylabel("Ice thickness (m)",'FontSize',16)
box on

ax4 = nexttile(4); %10Be
hold on
for i=1:length(sIDs) %sample index's
    patch([0 Tmax Tmax 0],[samples{sIDs(i)}.N10-samples{sIDs(i)}.dN10.*2 ...
        samples{sIDs(i)}.N10-samples{sIDs(i)}.dN10.*2 samples{sIDs(i)}.N10+samples{sIDs(i)}.dN10.*2. ...
        samples{sIDs(i)}.N10+samples{sIDs(i)}.dN10.*2 ],cols{i},'EdgeColor',cols{i},'FaceAlpha',.5)
    if i==1, text(5.5,samples{sIDs(i)}.N10-2e4,samples{sIDs(i)}.name,'Color',cols{i})
    else, text(5.5,samples{sIDs(i)}.N10+2e4,samples{sIDs(i)}.name,'Color',cols{i})
    end
end
xlim([0 Tmax]), ylim([0 1.5e5])
set(gca,'FontSize',14,'XTickLabel','')
text(.3,13.5e4,'d','fontsize',20)
box on

ax6 = nexttile(6); %26Al
hold on
for i=1:length(sIDs) %sample index's
    patch([0 Tmax Tmax 0],[samples{sIDs(i)}.N26-samples{sIDs(i)}.dN26.*2 ...
        samples{sIDs(i)}.N26-samples{sIDs(i)}.dN26.*2 samples{sIDs(i)}.N26+samples{sIDs(i)}.dN26.*2. ...
        samples{sIDs(i)}.N26+samples{sIDs(i)}.dN26.*2 ],cols{i},'EdgeColor',cols{i},'FaceAlpha',.5)
    if i==1, text(5.5,samples{sIDs(i)}.N26-1.5e5,samples{sIDs(i)}.name,'Color',cols{i})
    else, text(5.5,samples{sIDs(i)}.N26+1.5e5,samples{sIDs(i)}.name,'Color',cols{i})
    end
end
xlim([0 Tmax]), ylim([0 1e6])
set(gca,'FontSize',14)
text(.3,9e5,'f','fontsize',20)
box on

xlabel(t,"Time (ka BP)",'fontsize',16,'interpreter','latex')
Lstyles={'-','--','-.',':'};

%% Define ice-cover scenarios and calculate nuclide build-up
method=1; %three different methods implemented, choose 1, 2, or 3 to try them out
switch method
    case 1 % Method #1:choose a pre-defined scenario from 'define_ice_history.m'
        sc=6; % 1=8.2 ka event, 2=complete ice-free at 8.5ka, 3=ice-free at 5ka (LOI), 4=MIS3 exposure?, 5=UMISM, 6=lake record reconstruction
        [ice_hist,ts] = define_ice_history(sc,dt);

        uCol=[.9 .6 .6]; uCol2=brighten(uCol,-0.5); %colors CN production

        % Calculate cosmogenic nuclide inventories over time. [Note: 
        % calculated with production profile from first sample at each site
        % only, but they are very similar]

        % sample 1 and 2
        E=Esubgla; %Choose subglacial erosion rate for sample 1 and 2
        [b14C,b10Be,b26Al] = forward_CN_bedrock(ts,ice_hist,E,samples{1},consts);
        axes(ax1), yyaxis left
        patch([ts/1e3 fliplr(ts/1e3)],[0.923*b14C fliplr(1.077*b14C)],uCol,'EdgeColor','none','FaceAlpha',.8) %+/-7.7% reflecting site-to-site uncertainty on 'fitting parameter' for LSDn scaling
        plot(ts/1e3,b14C,'color',uCol2,'LineWidth',1,'Linestyle',Lstyles{1});
        yyaxis right
        plot(ts/1e3,(ice_hist./100),'LineWidth',2,'Linestyle',Lstyles{1})
        patch(ax2,[ts/1e3 fliplr(ts/1e3)],[0.966*b10Be fliplr(1.034*b10Be)],uCol,'EdgeColor','none','FaceAlpha',.8) %+/-3.4% reflecting site-to-site uncertainty on 'fitting parameter' for LSDn scaling
        plot(ax2,ts/1e3,b10Be,'color',uCol2,'LineWidth',1,'Linestyle',Lstyles{1});
        patch(ax5,[ts/1e3 fliplr(ts/1e3)],[0.931*b26Al fliplr(1.069*b26Al)],uCol,'EdgeColor','none','FaceAlpha',.8) %+/-6.9% reflecting site-to-site uncertainty on 'fitting parameter' for LSDn scaling
        plot(ax5,ts/1e3,b26Al,'color',uCol2,'LineWidth',1,'Linestyle',Lstyles{1});
        
        % sample 3 and 4 no erosion scenario
        E=Esubgla; %Choose subglacial erosion rate for sample 3 and 4
        [b14C,b10Be,b26Al] = forward_CN_bedrock(ts,ice_hist,E,samples{3},consts);
        axes(ax3), yyaxis left
        patch([ts/1e3 fliplr(ts/1e3)],[0.923*b14C fliplr(1.077*b14C)],uCol,'EdgeColor','none','FaceAlpha',.8) %+/-7.7% reflecting site-to-site uncertainty on 'fitting parameter' for LSDn scaling
        plot(ts/1e3,b14C,'color',uCol2,'LineWidth',1,'Linestyle',Lstyles{1});
        yyaxis right
        plot(ts/1e3,(ice_hist./100),'LineWidth',2,'Linestyle',Lstyles{1})
        patch(ax4,[ts/1e3 fliplr(ts/1e3)],[0.966*b10Be fliplr(1.034*b10Be)],uCol,'EdgeColor','none','FaceAlpha',.8) %+/-3.4% reflecting site-to-site uncertainty on 'fitting parameter' for LSDn scaling
        plot(ax4,ts/1e3,b10Be,'color',uCol2,'LineWidth',1,'Linestyle',Lstyles{1});
        patch(ax6,[ts/1e3 fliplr(ts/1e3)],[0.931*b26Al fliplr(1.069*b26Al)],uCol,'EdgeColor','none','FaceAlpha',.8) %+/-6.9% reflecting site-to-site uncertainty on 'fitting parameter' for LSDn scaling
        plot(ax6,ts/1e3,b26Al,'color',uCol2,'LineWidth',1,'Linestyle',Lstyles{1});

        % sample 3 and 4 erosion
        E=Esubgla1; %Choose subglacial erosion rate for sample 3 and 4
        [b14C,b10Be,b26Al] = forward_CN_bedrock(ts,ice_hist,E,samples{3},consts);
        axes(ax3), yyaxis left
        plot(ts/1e3,b14C,'color','k','LineWidth',2,'Linestyle',Lstyles{4});
        line([3.1 3.8],[2.7e5 2.7e5],'color','k','LineWidth',2,'Linestyle',Lstyles{4});
        text(4,2.7e5,['Subglacial erosion: ' num2str(E*10) ' mm yr$^{-1}$'],...
        'fontsize',14,'Color',.3*[1 1 1]) %Show info on subgl. erosion
        yyaxis right
        plot(ts/1e3,(ice_hist./100),'LineWidth',2,'Linestyle',Lstyles{4})
        plot(ax4,ts/1e3,b10Be,'color','k','LineWidth',2,'Linestyle',Lstyles{4});
        plot(ax6,ts/1e3,b26Al,'color','k','LineWidth',2,'Linestyle',Lstyles{4});


    case 2 % Method #2: hardcode some values in directly below for quick tests
        ice_times=[60000 55000 35000 30000 20000 9900 9800 7800 7790 5010 5000 4500 4450 1850 1800 105 55 37 0]; %time fixpoints (years prior to 2015)
        ice_cover=[100 0 0 100 100 100 35 35 0 0 35 35 0 0 35 35 25 19 0]*100; %Ice thickness at times in ice_times (cm)
       
        ts = (ice_times(1)-1):-dt:0; %time vector for calculations
        ice_hist=interp1(ice_times,ice_cover,ts); %interpolate ice-thickness at times in time vector

        % Calculate cosmogenic nuclide inventories over time, note calculated with 
        % production profile from first sample only, but they are very similar
        E=Esubgla; %Choose subglacial erosion rate for sample 1 and 2
        [b14C,b10Be,b26Al] = forward_CN_bedrock(ts,ice_hist,E,samples{1},consts);
        axes(ax1), plot(ts/1e3,b14C,'k','LineWidth',2);
%         text(2,2.78e5,['Subglacial erosion: ' num2str(E) ' cm a$^{-1}$'],...
%         'fontsize',14,'Color',.5*[1 1 1]) %Show info on subgl. erosion
        yyaxis right
        plot(ts/1e3,(ice_hist./100),'LineWidth',2)
        plot(ax2,ts/1e3,b10Be,'k','LineWidth',2);
        plot(ax5,ts/1e3,b26Al,'k','LineWidth',2);

        E=Esubgla1;  %Choose subglacial erosion rate for sample 3 and 4
        [b14C,b10Be,~] = forward_CN_bedrock(ts,ice_hist,E,samples{3},consts);
        axes(ax3), yyaxis left, plot(ts/1e3,b14C,'k','LineWidth',2);
        text(2,2.7e5,['Subglacial erosion: ' num2str(E*10) ' mm yr$^{-1}$'],...
            'fontsize',14,'Color',.5*[1 1 1]) %Show info on subgl. erosion
        yyaxis right
        plot(ts/1e3,(ice_hist./100),'LineWidth',2)
        plot(ax4,ts/1e3,b10Be,'k','LineWidth',2);
        plot(ax6,ts/1e3,b26Al,'k','LineWidth',2);

    case 3 % Method #3: Loop over one variable and plot to examine effect
%         HTM=[5,6,7,7.9]*1e3; %Beginning of full exposure during Holocene thermal maximum
        iThick=[11,30,45];
        for i=1:length(iThick) %(HTM)
%             ice_times=[20000 8000 HTM(i) 2500 105 55 37 0]; %time fixpoints (years prior to 2015)
%             ice_cover=[200 35 0 0 35 25 19 0]*100; %Ice thickness at times in ice_times (cm) 
            ice_times=[20000 9900 9800 7800 7790 5500 5450 4550 4500 1800 1750 105 55 37 0]; %time fixpoints (years prior to 2015)
            ice_cover=[50 50 iThick(i) iThick(i) 0 0 iThick(i) iThick(i) 0 0 iThick(i) iThick(i) 25 19 0]*100; %Ice thickness at times in ice_times (cm)
            ts = (ice_times(1)-1):-dt:0; %time vector for calculations
            ice_hist=interp1(ice_times,ice_cover,ts); %interpolate ice-thickness at times in time vector

            % Calculate cosmogenic nuclide inventories over time, note calculated with 
            % production profile from first sample only, but they are very similar

            E=Esubgla; %Choose subglacial erosion rate for sample 1 and 2
            [b14C,b10Be,b26Al] = forward_CN_bedrock(ts,ice_hist,E,samples{1},consts);
            axes(ax1), yyaxis left
            plot(ts/1e3,b14C,'k','LineWidth',1.5,'Linestyle',Lstyles{i});
%             text(2,2.78e5,['Subglacial erosion: ' num2str(E) ' cm a$^{-1}$'],...
%             'fontsize',14,'Color',.5*[1 1 1]) %Show info on subgl. erosion
            yyaxis right
            plot(ts/1e3,(ice_hist./100),'LineWidth',2,'Linestyle',Lstyles{i})
            plot(ax2,ts/1e3,b10Be,'k','LineWidth',2,'Linestyle',Lstyles{i});
            plot(ax5,ts/1e3,b26Al,'k','LineWidth',2,'Linestyle',Lstyles{i});

            E=Esubgla; %Choose subglacial erosion rate for sample 3 and 4
            [b14C,b10Be,b26Al] = forward_CN_bedrock(ts,ice_hist,E,samples{3},consts);
            axes(ax3), yyaxis left
            plot(ts/1e3,b14C,'k','LineWidth',1.5,'Linestyle',Lstyles{i});
%             text(2,2.7e5,['Subglacial erosion: ' num2str(E) ' cm a$^{-1}$'],...
%             'fontsize',14,'Color',.5*[1 1 1]) %Show info on subgl. erosion
            yyaxis right
            plot(ts/1e3,(ice_hist./100),'LineWidth',2,'Linestyle',Lstyles{i})
            plot(ax4,ts/1e3,b10Be,'k','LineWidth',2,'Linestyle',Lstyles{i});
            plot(ax6,ts/1e3,b26Al,'k','LineWidth',2,'Linestyle',Lstyles{i});
        end
end

set(gcf,'units','normalized','position',[.2,.3,.6,.6]);
% print -painters -depsc cosmo_1ero.eps

%%
set(groot','defaulttextinterpreter','default');
set(groot, 'defaultAxesTickLabelInterpreter','default'); 
set(groot, 'defaultLegendInterpreter','default');