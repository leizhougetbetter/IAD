clear
clc

numRepeat = 20;

w1 = [0.1:0.05:0.3,0.5:0.2:0.9];
FolderW1 = arrayfun(@(w1)({['w = ' num2str(w1,2)]}),w1);

FolderW2 = {'w = 1', 'w = 2.15', 'w = 4.65', 'w = 10'};

w = [w1, 1, 2.15, 4.65, 10];
FolderW = [FolderW1, FolderW2];

Ntotal = 100;
%% Set 1
arrayMeanA1 = [];
for indexW = 1 : length(w)
    meanARepeat = [];
    FolderNow = ['SetOne-0to1\' FolderW{indexW} '\'];             
          
    data = importdata([FolderNow 'numA_Strategy_Dist']);
    
    probDist = data / sum(data(1,:));
    avgA = probDist * ((0:1:Ntotal) * 1.0 / Ntotal)';

    arrayMeanA1 = [arrayMeanA1, mean(avgA)];
end

%% Set 2
probDist = zeros(numRepeat, Ntotal + 1);
arrayMeanA2 = [];
for indexW = 1 : length(w)
    meanARepeat = [];
    FolderNow = ['SetTwo-0to1\' FolderW{indexW} '\'];
 
    data = importdata([FolderNow 'numA_Strategy_Dist']);
    
    probDist = data / sum(data(1,:));
    avgA = probDist * ((0:1:Ntotal) * 1.0 / Ntotal)';

    arrayMeanA2 = [arrayMeanA2, avgA(end)];
end

figure(1)
semilogx(w,arrayMeanA1, 'ro','MarkerSize',11,'linewidth',2);
hold on;
semilogx(w, arrayMeanA2,'bs','MarkerSize',11,'linewidth',2)
set(gca,'YTick',0:0.05:1.0)
set(gca,'YTickLabel',{'0.0','','0.1','','0.2','','0.3','','0.4','','0.5','','0.6','','0.7','','0.8','','0.9','','1.0'}, 'fontsize',13)
xtickLabel = get(gca,'XTickLabel');
set(gca,'XTickLabel',xtickLabel,'fontsize',13)

hL = legend('Set 1','Set 2', 'location','northwest');
hL.FontSize = 13;
legend('boxoff')
title('Aspiration ~ \itU\rm[0,1]','fontsize',14, 'FontWeight','normal')
xlim([0.08,12])
ylim([0.25,0.75])
axis square
