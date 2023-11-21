function ax = initiateCFig(sIDs,samples)

% Developed by Jane Lund Andersen, Aarhus University 
% (jane.lund@geo.au.dk), 2021-22

Tstart = 12; %Sets the time-range for plotting (ka BP), but does not control the model start

%% initiate figures and plot sample data
figure(1) 
t = tiledlayout(3,1,'TileSpacing','compact');

ax1 = nexttile(1); %14C
if length(sIDs)==2
    tname=['Samples: ' char(samples{sIDs(1)}.name) ' and ' char(samples{sIDs(2)}.name)];
else
    tname=['Sample: ' char(samples{sIDs(1)}.name)];
end
title(tname,'interpreter','latex','FontSize',16)

colororder([.1 .1 .1; .3 .4 1])
yyaxis left
hold on
cols={[.5 .2 .2] [.2 .2 .5]};
for i=1:length(sIDs) %sample index's
    patch([0 Tstart Tstart 0],[samples{sIDs(i)}.N14-samples{sIDs(i)}.dN14.*2 ...
        samples{sIDs(i)}.N14-samples{sIDs(i)}.dN14.*2 samples{sIDs(i)}.N14+samples{sIDs(i)}.dN14.*2. ...
        samples{sIDs(i)}.N14+samples{sIDs(i)}.dN14.*2 ],cols{i},'EdgeColor',cols{i},'FaceAlpha',.5)
    if i==1, text(11,samples{sIDs(i)}.N14-6*samples{sIDs(i)}.dN14,samples{sIDs(i)}.name,'Color',cols{i})
    else, text(11,samples{sIDs(i)}.N14+6*samples{sIDs(i)}.dN14,samples{sIDs(i)}.name,'Color',cols{i})
    end
end
xlim([0 Tstart]), %ylim([0 3e5])
set(gca,'FontSize',12)
ylabel("$^{14}$C (at g$^{-1}$)",'fontsize',16) %ylabel("C-14 (at g$^{-1}$)",'fontsize',16)
% text(.3,2.8e5,'a','fontsize',20)

ax2 = nexttile(2); % 10Be
hold on
for i=1:length(sIDs) %sample index's
    patch([0 Tstart Tstart 0],[samples{sIDs(i)}.N10-samples{sIDs(i)}.dN10.*2 ...
        samples{sIDs(i)}.N10-samples{sIDs(i)}.dN10.*2 samples{sIDs(i)}.N10+samples{sIDs(i)}.dN10.*2. ...
        samples{sIDs(i)}.N10+samples{sIDs(i)}.dN10.*2 ],cols{i},'EdgeColor',cols{i},'FaceAlpha',.5)
    if i==1, text(11,samples{sIDs(i)}.N10-4*samples{sIDs(i)}.dN10,samples{sIDs(i)}.name,'Color',cols{i})
    else, text(11,samples{sIDs(i)}.N10+4*samples{sIDs(i)}.dN10,samples{sIDs(i)}.name,'Color',cols{i})
    end
end
xlim([0 Tstart]), yl=ylim; ylim([0 1.2*yl(2)]) 
set(gca,'FontSize',12)
ylabel("$^{10}$Be (at g$^{-1}$)",'FontSize',16) % ylabel("Be-10 (at g$^{-1}$)",'FontSize',16)
% text(.3,2.8e5,'b','fontsize',20)

ax3 = nexttile(3); % 26Al
hold on
for i=1:length(sIDs) %sample index's
    patch([0 Tstart Tstart 0],[samples{sIDs(i)}.N26-samples{sIDs(i)}.dN26.*2 ...
        samples{sIDs(i)}.N26-samples{sIDs(i)}.dN26.*2 samples{sIDs(i)}.N26+samples{sIDs(i)}.dN26.*2. ...
        samples{sIDs(i)}.N26+samples{sIDs(i)}.dN26.*2 ],cols{i},'EdgeColor',cols{i},'FaceAlpha',.5)
    if i==1, text(11,samples{sIDs(i)}.N26-4*samples{sIDs(i)}.dN26,samples{sIDs(i)}.name,'Color',cols{i})
    else, text(11,samples{sIDs(i)}.N26+4*samples{sIDs(i)}.dN26,samples{sIDs(i)}.name,'Color',cols{i})
    end
end
xlim([0 Tstart]), yl=ylim; ylim([0 1.2*yl(2)]) 
set(gca,'FontSize',12,'YTick',0:2e5:2e6)
ylabel("$^{26}$Al (at g$^{-1}$)",'FontSize',16) %ylabel("Al-26 (at g$^{-1}$)",'FontSize',16)
% text(.3,1.8e6,'c','fontsize',20)

xlabel(t,"Time (ka BP)",'fontsize',16,'interpreter','latex')

ax.ax1=ax1; ax.ax2=ax2; ax.ax3=ax3;
