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

%% describing OMSI by differential motion
figure(2)
scatterByCellType(analyzedCells.differential, analyzedCells.object, colors(groupID));
ylabel('Moving object OMSI')
xlabel('Differential motion OMSI')


%% describing OMSI by reversing contrast
figure(2)
scatterByCellType(analyzedCells.contrastReversing, analyzedCells.object, colors(groupID));
ylabel('Moving object OMSI')
xlabel('Reversing contrast OMSI')

%% describing OMSI by SMS
figure(2)
scatterByCellType(analyzedCells.sms, analyzedCells.object, colors(groupID));
ylabel('Moving object OMSI')
xlabel('Suppression (SI)')


%% comparing to linear effect mixed model
rsquared = nan([3,2]);

% differential
lme = fitlme(analyzedCells, 'object~differential+(differential|cellType)');
rsquared(1,1) = lme.Rsquared.Adjusted;

correlation = corrcoef(analyzedCells.object,analyzedCells.differential);
rsquared(1,2) = correlation(2,1) .^ 2;

% reversing contrast
lme = fitlme(analyzedCells, 'object~contrastReversing+(contrastReversing|cellType)');
rsquared(2,1) = lme.Rsquared.Adjusted;

correlation = corrcoef(analyzedCells.object,analyzedCells.contrastReversing);
rsquared(2,2) = correlation(2,1) .^ 2;

% SMS
lme = fitlme(analyzedCells, 'object~sms+(sms|cellType)');
rsquared(3,1) = lme.Rsquared.Adjusted;

correlation = corrcoef(analyzedCells.object,analyzedCells.sms);
rsquared(3,2) = correlation(2,1) .^ 2;

% plot bar graph
figure(3)
bar(rsquared)



