function OMS_dataTable = omsDataGrabber(TreeBrowserGUI)
T = TreeBrowserGUI.analysisTree;

nodes = getTreeLevel_new(T, 'class', 'ObjectMotionSensitivityAnalysis');

data = struct();

for i=1:length(nodes)
    datasetNodes = T.subtree(nodes(i));
    parentNode = datasetNodes.Node{1};
    
    cellData = loadAndSyncCellData(parentNode.cellName);

    data.cellName{i, 1} = parentNode.cellName;
    data.cellType{i, 1} = cellData.cellType;
    data.dataset{i,1} = parentNode.name;
    data.pattern{i, 1} = cellData.epochs(datasetNodes.Node{2}.epochID(1)).get('patternMode');
    data.width(i, 1) = cellData.epochs(datasetNodes.Node{2}.epochID(1)).get('patternSpatialScale');
    data.motionPath{i, 1} = cellData.epochs(datasetNodes.Node{2}.epochID(1)).get('motionPathMode');

    %% center response
    data.centerSpikeRate(i, 1) = parentNode.spikeRate_objectMovement.mean_c(1);
    data.centerStd(i,1) = parentNode.spikeRate_objectMovement.SD_c(1);
    data.centerN(i,1) = parentNode.spikeRate_objectMovement.N(1);

    %% surround response
    data.surroundSpikeRate(i, 1) = parentNode.spikeRate_objectMovement.mean_c(2);
    data.surroundStd(i,1) = parentNode.spikeRate_objectMovement.SD_c(2);
    data.surroundN(i,1) = parentNode.spikeRate_objectMovement.N(2);

    %% global response
    data.globalSpikeRate(i, 1) = parentNode.spikeRate_objectMovement.mean_c(3);
    data.globalStd(i,1) = parentNode.spikeRate_objectMovement.SD_c(3);
    data.globalN(i,1) = parentNode.spikeRate_objectMovement.N(3);

    %% differential response
    data.differentialSpikeRate(i, 1) = parentNode.spikeRate_objectMovement.mean_c(4); 
    data.differentialStd(i,1) = parentNode.spikeRate_objectMovement.SD_c(4);
    data.differentialN(i,1) = parentNode.spikeRate_objectMovement.N(4);
    
    %% OMSI
    differntialSpikes = datasetNodes.Node{5}.spikeRate_objectMovement.value;
    globalSpikes = datasetNodes.Node{4}.spikeRate_objectMovement.value;
    
    [omsi, standDev] =  analyticalCV(differntialSpikes, globalSpikes);
    data.OMSI(i,1) = omsi;
    data.OMSI_std(i,1) = standDev;
    
    %% SI
    centerSpikes = datasetNodes.Node{2}.spikeRate_objectMovement.value;
    surroundSpikes = datasetNodes.Node{3}.spikeRate_objectMovement.value;
    
    [si, standDev] =  analyticalCV(centerSpikes, globalSpikes);
    data.SI(i,1) = si;
    data.SI_std(i,1) = standDev;
end

OMS_dataTable = struct2table(data);
OMS_dataTable(strcmp(OMS_dataTable.motionPath, 'random walk'), 'motionPath') = {'differential motion'};
OMS_dataTable(strcmp(OMS_dataTable.motionPath, 'filtered noise'), 'motionPath') = {'object motion'};
end