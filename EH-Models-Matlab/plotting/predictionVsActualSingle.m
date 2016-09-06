function predictionVsActualSingle(instances, pickedInstanceIDs, numParamCombinations, figNoStart)
colours = {'b','g','r','m','k','y','c','b','g','r','c','m','y','k'};
symbols = {'.','o','x','s','*','+','d','v','^','<','>','p','h'};

inst_keys = keys(instances);
N = length(inst_keys);

params = 1:numParamCombinations;

if numParamCombinations == 30
    defind = 18;  % 1.3, 0.8
    numAlphas = 3;
    numRhos=10;
    labels = {'0';'.1';'.2';'.3';'.4';'.5';'.6';'.7';'.8';'.9';'0';'.1';'.2';'.3';'.4';'.5';'.6';'.7';'.8';'.9';'0';'.1';'.2';'.3';'.4';'.5';'.6';'.7';'.8';'.9'};
elseif numParamCombinations == 6
    defind = 5;  % 50%
    numAlphas = 1;
    numRhos = 6;
    labels = {'10';'20';'30';'40';'50';'60'};
elseif numParamCombinations == 1
    defind = 1;  % 50%
    numAlphas = 1;
    numRhos = 1;
    labels = {'1'};
end

for n=1:length(pickedInstanceIDs)
    kmod1 = mod(n-1,length(colours))+1;
    kmod2 = mod(n-1,length(symbols))+1;

    legendstr = {};
    handles = [];

    figure(n+figNoStart-1);
    hold off

    entry = get(instances, pickedInstanceIDs(n));

    yTests = [];
    yPreds = [];
    for j=1:length(entry)
        yTests(j) = entry{j}.yTest;
        yPreds(j) = entry{j}.yPred;
    end

    h=plot(params,yTests, strcat(strcat(colours{kmod1},symbols{kmod2})));
    handles(end+1)=h;
    legendstr{end+1} = 'true SAPS median';
    hold on
    h=plot(params,yPreds, 'k-');
    handles(end+1)=h;
    legendstr{end+1} = 'predicted SAPS median';
    legend(handles, legendstr, 'Location', 'North')
    legendstr = {};
    handles = [];
    hold off
    
    for i=0:numAlphas-1
        idx = i*numRhos+1:i*numRhos+numRhos;
        h=plot(params(idx),yTests(idx), '.k:','LineWidth', 2, 'MarkerSize', 20);
        hold on 
        if i==0
            handles(end+1)=h;
            legendstr{end+1} = 'true SAPS median';
        end
        h=plot(params(idx),yPreds(idx), strcat(strcat(strcat(colours{i+1},symbols{i+1})),'-'),'LineWidth', 2, 'MarkerSize', 9);
        handles(end+1)=h;
        legendstr{end+1} = strcat('prediction, ', strcat('alpha = 1.', num2str(i+2)));
    end
    legend(handles, legendstr, 'Location', 'North')
%    legend(handles, legendstr);%, 'Location', 'North', 'FontSize', 16);
    xlabel('rho', 'FontSize', 16);
    h=gca;
    set(h, 'XTick', params);
    set(h,'XTickLabel',labels);
    ylabel('Log10 median runtime (mean +/- std) [seconds]', 'FontSize', 16);
        
    title('Log10 median runtime vs. parameter combination', 'FontSize', 16);

%        axis([0 17 1.5 5]); %uf
%        axis([0 17 2 5.5]); %bigmix
%        axis([0 17 3 6]) %sat
end
