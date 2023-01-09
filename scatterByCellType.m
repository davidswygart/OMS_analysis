function plt = scatterByCellType(x,y, colorData)

clf
plt = scatter(x, y, 'filled');
plt.MarkerFaceColor = "flat";
plt.CData = colorData;

hold on
plot([-1,1], [-1,1],'--k')% unity line
plot([-1, 1], [0,0], 'k')% x axis
plot([0,0], [-1, 1], 'k')% y axis
xlim([-.4,1])
ylim([-.4,1])

% plot r-squared
correlation = corrcoef(x,y);
rSquared = correlation(2,1) .^ 2;
textString =['r^{2} = ', num2str(round(rSquared,2))];
text(0.2, 0.8, textString)

end