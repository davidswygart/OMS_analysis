function plotBar(plotWhat, splitBy)
G = findgroups(splitBy);
splitParam = unique(splitBy);

groupAvg = splitapply(@mean, plotWhat, G);
groupSTD = splitapply(@mean, plotWhat, G);
groupN = splitapply(@length, plotWhat, G);

x = categorical(splitParam);
y = groupAvg;


bar(x,y)
errorbar(1:length(groupAvg), y, groupSTD, 'black', 'LineStyle', 'none')
end