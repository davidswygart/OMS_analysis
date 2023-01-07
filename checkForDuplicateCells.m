function checkForDuplicateCells(dataTable)

% loop below checks that we have narrowed the data down to 1 value per cell
cellNames = unique(dataTable.cellName);
for i = 1:length(cellNames)
    numCells = sum(strcmp(dataTable.cellName, cellNames(i)));
    if (numCells ~= 1)
        error('not exactly 1 cell match')
    end
end
end