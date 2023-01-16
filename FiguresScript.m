%% %%%%%%%%%%%%%%%%%%%%%% Figure 1 - OMS accross cell types %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
table = OMS_dataTable((strcmp(OMS_dataTable.pattern, 'grating')),:);
table = table((table.width > 79 & table.width <101),:);
objectMotionTable = table(strcmp(table.motionPath, 'object motion'), :); 
objectMotionTable = objectMotionTable(~isnan(objectMotionTable.OMSI_std), :); % get rid of nans (no spikes in both differential and global)
checkForDuplicateCells(objectMotionTable);

% looking at confidence of OMSI value calculation for each cell
figure(1)
histogram(objectMotionTable.OMSI_std,20)
xlabel('standard deviation of OMSI calculation')
ylabel('cell count')
objectMotionTable = objectMotionTable(objectMotionTable.OMSI_std < 0.3, :); % get rid of uncertain OMSI values

%% Using manually curated data from Excel sheet
figure(10)
[groupID, groupNames, colors] = plotBar(analyzedCells.object, analyzedCells.cellType);
ylabel('Moving object OMSI')
ylim([-.4, 1.1])
% 
% [p, tbl, stats] = anova1(analyzedCells.object, groupID);
% results = multcompare(stats);
% pvals = results(:,6);
% groups = results(:,1:2);
% significantGroups = unique(groups(pvals < .05, :));

%%
rsquared = nan([3,2]);


%% describing OMSI by differential motion
% linear regression
figure(2)
[plt, linReg_diff] = scatterByCellType(analyzedCells.differential, analyzedCells.object, colors(groupID));
ylabel('Moving object OMSI')
xlabel('Differential motion OMSI')
xlim([-.4,1])
ylim([-.4,1])
title('')
rsquared(1,1) = linReg_diff.Rsquared.Ordinary;

%linear mixed effect model
lme_diff = fitlme(analyzedCells, 'object~differential+(differential|cellType)');
rsquared(1,2) = lme_diff.Rsquared.Adjusted;
saveas(gcf, 'differentialScatter.png')
%% describing OMSI by reversing contrast
% linear regression
figure(2)
[plt, linReg_revCon]  = scatterByCellType(analyzedCells.contrastReversing, analyzedCells.object, colors(groupID));
ylabel('Moving object OMSI')
xlabel('Reversing contrast OMSI')
xlim([-.4,1])
ylim([-.4,1])
title('')
rsquared(2,1) = linReg_revCon.Rsquared.Ordinary;

%linear mixed effect model
lme_revCon = fitlme(analyzedCells, 'object~contrastReversing+(contrastReversing|cellType)');
rsquared(2,2) = lme_revCon.Rsquared.Adjusted;
saveas(gcf, 'reversingContrastScatter.png')
%% describing OMSI by SMS
% linear regression
figure(2)
[plt, linReg_sms] = scatterByCellType(analyzedCells.sms, analyzedCells.object, colors(groupID));
ylabel('Moving object OMSI')
xlabel('Suppression (SI)')
xlim([-.4,1])
ylim([-.4,1])
title('')
rsquared(3,1) = linReg_sms.Rsquared.Ordinary;

%linear mixed effect model
lme_sms = fitlme(analyzedCells, 'object~sms+(sms|cellType)');
rsquared(3,2) = lme_sms.Rsquared.Adjusted;
saveas(gcf, 'smsScatter.png')
%% comparing linear regression to mixed effects model
% plot bar graph
figure(3)
clf
types = {'differential motion', 'reversing contrast', 'fixed spots'};
x = categorical(types);
x = reordercats(x,types);
bar(x, rsquared)
ylabel('R^2')
legend('linear regression','linear mixed-effects')
ylim([0,1])
saveas(gcf, 'mixedEffectsRsquared.png')

%%
figure(4);
clf

lme_sms = fitlme(analyzedCells, 'object~sms+(sms|cellType)');
lme_sms = fitlme(analyzedCells, 'object~sms+cellType+(1|cellType)+(sms-1|cellType)');

mdl = lme_diff;
mdl = lme_revCon;
mdl = lme_sms;

var_names = categorical(mdl.CoefficientNames(1:end));
bar(var_names, mdl.Coefficients.Estimate(1:end), 'FaceColor',[0.5,0.5,0.5],'EdgeColor','k');
set(gca, 'TickLabelInterpreter', 'none')
hold('on');
errorbar(var_names, mdl.Coefficients.Estimate(1:end), ...
    mdl.Coefficients.SE(1:end)*1.96, 'k.');

hold('off');
%% example plots
figure(2)
fig = gcf;
axObjs = fig.Children;
dataObjs = axObjs.Children;
lineNumber = 5;

x = dataObjs(lineNumber).XData;
y = dataObjs(lineNumber).YData;

figure(24)
plot(x,y, 'k')
xlim([5,10])
axis off