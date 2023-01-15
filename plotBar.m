function [groupID, splitParam, colors] = plotBar(plotWhat, splitBy)

[splitParam,~, groupID ] = unique(splitBy, 'stable'); %leaves group values in same order as recieved

groupAvg = splitapply(@mean, plotWhat, groupID);
groupSTD = splitapply(@std, plotWhat, groupID);
groupN = splitapply(@length, plotWhat, groupID);
groupSEM = groupSTD  ./ sqrt(groupN);

x = categorical(splitParam);
x = reordercats(x,splitParam);
y = groupAvg;

clf
barGraph = bar(x,y, 'FaceColor','flat');
colors = colormap;
colors = colors(round(linspace(1,256, length(splitParam))'), :);
barGraph.CData = colors;


hold on
err = groupSEM;
errorbar(1:length(groupAvg), y, err, 'black', 'LineStyle', 'none')

allX = categorical(splitBy);
scatter(allX, plotWhat, 'black', 'filled')

% ANOVA
[~, ~, stats] = anova1(plotWhat, groupID, 'off');
results = multcompare(stats, 'Display','off');
pvals = results(:,6);
groups = results(:,1:2);
significantGroups = unique(groups(pvals < .05, :));
groupNames = categorical(splitParam(significantGroups));
scatter(groupNames, ones(length(significantGroups),1)*-.3, '*r');


hold off

end