function plot_pred_vs_actual_single(colours, symbols, pickedInstances, yTest, yPred, numdiff, params, numalphas, numrhos, labels, figNoStart)

yTest = yTest(:,pickedInstances);
yPred = yPred(:,pickedInstances);
[numdiff, N] = size(yTest)

for p=1:N
    kmod1 = mod(p-1,length(colours))+1;
    kmod2 = mod(p-1,length(symbols))+1;

    legendstr = {};
    handles = [];

    figure(p+figNoStart-1);
    hold off

    h=plot(params,yTest(:,p), strcat(strcat(colours{kmod1},symbols{kmod2})));
    handles(end+1)=h;
    legendstr{end+1} = 'true SAPS median';
    hold on
    h=plot(params,yPred(:,p), 'k-');
    handles(end+1)=h;
    legendstr{end+1} = 'predicted SAPS median';
    legend(handles, legendstr, 'Location', 'North')
    legendstr = {};
    handles = [];
    hold off

    for i=0:numalphas-1
        idx = i*numrhos+1:i*numrhos+numrhos;
        h=plot(params(idx),yTest(idx,p), '.k:','LineWidth', 2, 'MarkerSize', 20);
        hold on 
        if i==0
            handles(end+1)=h;
            legendstr{end+1} = 'true SAPS median';
        end
        h=plot(params(idx),yPred(idx,p), strcat(strcat(strcat(colours{i+1},symbols{i+1})),'-'),'LineWidth', 2, 'MarkerSize', 9);
        handles(end+1)=h;
        legendstr{end+1} = strcat('prediction, ', strcat('alpha = 1.', num2str(i+2)));
    end
    legend(handles, legendstr, 'Location', 'North', 'FontSize', 16);
    xlabel('rho', 'FontSize', 16);
    h=gca;
    set(h, 'XTick', 1:numalphas*numrhos);
    set(h,'XTickLabel',labels);
    ylabel('Log10 median runtime (mean +/- std) [seconds]', 'FontSize', 16);
    
    
    global notitle
    if notitle
        fprintf('Log10 median runtime vs. parameter combination')
    else
        title('Log10 median runtime vs. parameter combination', 'FontSize', 16);
    end

%        axis([0 17 1.5 5]); %uf
%        axis([0 17 2 5.5]); %bigmix
%        axis([0 17 3 6]) %sat
end
