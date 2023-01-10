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
figure(1)
[groupID, colors] = plotBar(analyzedCells.object, analyzedCells.cellType);
ylabel('Moving object OMSI')


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
lme_obj = fitlme(analyzedCells, 'object~differential+(differential|cellType)');
rsquared(1,2) = lme_obj.Rsquared.Adjusted;

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


