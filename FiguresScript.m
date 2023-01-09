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

% looking at OMSI for each cell type
figure(2)
plotBar(objectMotionTable.OMSI, objectMotionTable.cellType)
