%% %%%%%%%%%%%%%%%%%%%%%% Figure 1 - OMS accross cell types %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
table = OMS_dataTable((strcmp(OMS_dataTable.pattern, 'grating')),:);
table = table((table.width > 79 & table.width <101),:);
objectMotionTable = table(strcmp(table.motionPath, 'object motion'), :); 

objectMotionTable = objectMotionTable(~isnan(objectMotionTable.OMSI_std), :); % get rid of nans (no spikes in both differential and global)
objectMotionTable = objectMotionTable(objectMotionTable.OMSI_std < 0.2, :); % get rid of uncertain OMSI values (probably )

checkForDuplicateCells(objectMotionTable);

plotBar(objectMotionTable.OMSI, objectMotionTable.cellType)
