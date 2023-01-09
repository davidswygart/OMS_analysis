function OMS_dataTable = smsDataGrabber(TreeBrowserGUI, smallSpotSize)
T = TreeBrowserGUI;
nodes = getTreeLevel_new(T, 'class', 'SpotsMultiSizeAnalysis');

data = struct();

for i=1:length(nodes)
    datasetNodes = T.subtree(nodes(i));
    parentNode = datasetNodes.Node{1};
    
    cellData = loadAndSyncCellData(parentNode.cellName);

    data.cellName{i, 1} = parentNode.cellName;
    data.cellType{i, 1} = cellData.cellType;
    data.dataset{i,1} = parentNode.name;
    
    %% spikes counted
    spotSizes = parentNode.spotSize;
    [~, smallSpotIndex] = min(abs(spotSizes - smallSpotSize));
    largeSpotIndex = length(spotSizes);
    
    smallSpotSpikes = datasetNodes.Node{smallSpotIndex+1}.spikeCount_stimToEnd.value;
    largeSpotSpikes = datasetNodes.Node{largeSpotIndex+1}.spikeCount_stimToEnd.value;

    %% small spot response
   
    data.smallSpotResponse(i, 1) = mean(smallSpotSpikes);
    data.smallSpotStd(i,1) = std(smallSpotSpikes);
    data.smallSpotN(i,1) = length(smallSpotSpikes);

    %% large spot response
    data.largeSpotResponse(i, 1) = mean(largeSpotSpikes);
    data.largeSpotStd(i,1) = std(largeSpotSpikes);
    data.largeSpotN(i,1) = length(largeSpotSpikes);
    
    %% Suppression index (SI)
    [si, standDev] =  analyticalCV(smallSpotSpikes, largeSpotSpikes);
    data.SI(i,1) = si;
    data.SI_std(i,1) = standDev;
end

OMS_dataTable = struct2table(data);
end