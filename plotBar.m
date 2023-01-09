function plotBar(plotWhat, splitBy)
G = findgroups(splitBy);
splitParam = unique(splitBy);

groupAvg = splitapply(@mean, plotWhat, G);
groupSTD = splitapply(@std, plotWhat, G);
groupN = splitapply(@length, plotWhat, G);
groupSEM = groupSTD  ./ sqrt(groupN);

x = categorical(splitParam);
y = groupAvg;

clf
bar(x,y)
hold on
err = groupSEM;
errorbar(1:length(groupAvg), y, err, 'black', 'LineStyle', 'none')
scatter(G, plotWhat, 'black', 'filled')
hold off
end