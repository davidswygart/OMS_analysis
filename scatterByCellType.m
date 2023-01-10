function [plt, mdl] = scatterByCellType(x,y, colorData)

clf

%% plot linear model
mdl = fitlm(x,y);
h = plot(mdl);
delete(h(1)); % delete datapoints. I want to plot them below with custom colors
hold on
%% plot datapoints colored by colorData
plt = scatter(x, y, 'filled');
plt.MarkerFaceColor = "flat";
plt.CData = colorData;

%% plot x and y axis
plot([-1, 1], [0,0], 'k')% x axis
plot([0,0], [-1, 1], 'k')% y axis

%% plot legend and r-squared
rSquared = mdl.Rsquared.Ordinary;
textString =['r^{2} = ', num2str(round(rSquared,2))];
text(0.05, 0.85, textString)

l = legend;
delete(l)
pbaspect([1 1 1])
end