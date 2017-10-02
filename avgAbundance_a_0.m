clear
clc

a0 = 1.6 : 0.1 : 2.4;
beta = 0.01;


meanA_A0 = [];
for indexA0 = 1 : length(a0)
    data = importdata(['numA_Dist_a0_' num2str(a0(indexA0),'%4.2f')]);
    meanARepeat = [];
    for iRepeat = 1 : 200
        dataNow = data(iRepeat,:);
        numAUnique = unique(find(dataNow>0));
        timesState = dataNow(numAUnique);
        probState = timesState * 1.0 / sum(dataNow);
        meanA = sum((numAUnique-1) .* probState)/100;
        meanARepeat = [meanARepeat, meanA];
    end
    meanA_A0 = [meanA_A0; mean(meanARepeat)];
end
sizeMarker = 10;
h1 = plot(a0,meanA_A0,'d','MarkerSize',sizeMarker, 'linewidth',2);
hold on;
plot([1.55,2.45],[0.5, 0.5],'k--','linewidth',2)
h3 = plot([1.55,2.45], 0.5+1/2^5*([1.55,2.45]-2)*beta,'r-','linewidth',2);
legend([h1,h3],{'Simulation','Analytical'})
title('\beta = 0.01, d = 3')
xlim([1.55,2.45])
ylim([0.4998, 0.5002])