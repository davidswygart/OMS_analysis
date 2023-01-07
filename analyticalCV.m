function [si, standDev] =  analyticalCV(center, surround)

centerRep = repmat(center, [length(surround),1]);
surroundRep = repmat(surround', [1,length(center)]);

allSI = (centerRep - surroundRep) ./ (centerRep + surroundRep);


si = mean(allSI(:));
standDev = std(allSI(:));
end