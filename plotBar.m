function [groupID, colors] = plotBar(plotWhat, splitBy)

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
scatter(groupID, plotWhat, 'black', 'filled')
hold off

end