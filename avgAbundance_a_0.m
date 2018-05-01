clear
clc


figure; 
sizeMarker = 10;
selectionIntensity = 0.005;

a0Array = 1.6 : 0.1 : 2.4;
xPlot = 1.55 : 0.1 : 2.55;

meanA_a0_OneDist = [];
for a0 = 1.6 : 0.1 : 2.4
    
    meanA_a0_Array = [];
    folder = ['a0-' num2str(a0,'%3.1f') '\'];
    
    for iRepeat = 1 : 3
        
        wholeDist = importdata([folder 'numA_Strategy_Dist_repeat_' num2str(iRepeat)]);
        
        probDist = wholeDist /  sum(wholeDist);
        avgA = sum((0:1:1000)/1000 .* probDist);
        meanA_a0_Array  = [meanA_a0_Array; avgA];
    end
    meanA_a0_OneDist = [meanA_a0_OneDist; mean(meanA_a0_Array)];
end

plot(a0Array,meanA_a0_OneDist,'o','markersize',sizeMarker,'linewidth',1.5)
hold on;

plot(xPlot, 0.5+1/2^5*(xPlot-2)*selectionIntensity,'r-', 'linewidth',2)
plot([1.55, 2.45], [0.5,0.5],'k--',  'linewidth',2)
xlim([1.55,2.45])
ylim([0.49991,0.50009])
axis square

legend({'Simulation', 'Analytical'}, 'location','southeast', 'fontsize',11);
title('Power-law distributed aspirations, SF')
ylabel('Average abundance of strategy A', 'fontsize', 16)
xlabel('$$a_0$$','Interpreter','latex','fontsize', 16)
