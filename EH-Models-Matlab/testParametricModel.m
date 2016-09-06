function [rmse,cc,rmseReal] = testParametricModel(modelFilename, xTest, yTest, testInstanceIDs)

%========================================================================
% 1. Get predictions.
%========================================================================
[yPred, yPredStd] = predictTransformed(modelFilename, xTest);

%========================================================================
% 2. Plot like parameterless data.
%========================================================================
modelStruct = load(modelFilename);
transformation = modelStruct.transformation;
config = modelStruct.config;
yTest = transformResponse(transformation.responseTransformation, yTest);

[rmse, cc_all] = correlationPlot(yTest, yPred, 1, 1)

%========================================================================
% 3. Build hashtable instances{id} = cell array of structs with xTest and yTest.
%========================================================================
instances = hashtable;
for n=1:length(testInstanceIDs)
    inst_data.xTest = xTest(n,:);
    inst_data.yTest = yTest(n);
    inst_data.yPred = yPred(n);
    inst_data.yPredStd = yPredStd(n);
    datas = get(instances, int2str(testInstanceIDs(n)));
    datas = [datas, inst_data];
    instances = put(instances, int2str(testInstanceIDs(n)), datas);
end
inst_keys = keys(instances);
N = length(inst_keys);

%========================================================================
% 4. Compute statistics for each instance.
%========================================================================
avgHardness = zeros(N,1);
avgPredHardness = zeros(N,1);
corrcoefs = zeros(N,1);

numParamCombinations=0;
for n=1:N
    entry = get(instances, inst_keys(n));

    yTests = [];
    yPreds = [];
    for j=1:length(entry)
        yTests(j) = entry{j}.yTest;
        yPreds(j) = entry{j}.yPred;
    end
    avgHardness(n) = mean(yTests);
    avgPredHardness(n) = mean(yPreds);
    numParamCombinations = max(numParamCombinations, length(entry));

    cc = corrcoef(yTests,yPreds);
    if(length(cc)>1) cc = cc(1,2);end
    corrcoefs(n) = cc;
end

cc = mean(corrcoefs);
stdcc = std(corrcoefs);

%========================================================================
% 5. Pick interesting instances.
%========================================================================
[tmp, idx] = sort(avgHardness);
q0 = idx(1);
q010 = idx(floor(N*0.10)+1);
q025 = idx(floor(N*0.25)+1);
q05 = idx(floor(N*0.5)+1);
q075 = idx(floor(N*0.75)+1);
q090 = idx(floor(N*0.90)+1);
q1 = idx(length(idx));

[tmp, idx] = sort(avgPredHardness,1);
q0pred = idx(1);
q1pred = idx(length(idx));

pickedInstanceKeyNumbers = unique([q0, q010, q025, q05, q075, q090, q1, q0pred, q1pred]);
pickedInstanceIDs = inst_keys(pickedInstanceKeyNumbers);

%========================================================================
% 6. Plot the interesting instances.
%========================================================================
%parametricCorrelationPlot(instances, pickedInstanceIDs, cc, stdcc, rmse, 2);

%========================================================================
% 7. Plot fits for each interesting instance.
%========================================================================
%predictionVsActualSingle(instances, pickedInstanceIDs, numParamCombinations, 3);

%========================================================================
% 8. Evaluate the automatic parameter tuning.
%========================================================================

yData = modelStruct.yData;
yData = reshape(yData, [numParamCombinations, length(yData)/numParamCombinations]);

[N,K] = size(xTest);
nInstances = N/numParamCombinations;
yTest = reshape(yTest, [numParamCombinations, nInstances]);
yPred = reshape(yPred, [numParamCombinations, nInstances]);
testInstanceIDs = reshape(testInstanceIDs, [numParamCombinations, nInstances]);

if numParamCombinations == 30
    defind = 19;  % 1.3, 0.8
    numalphas=3;
    numrhos=10;
    labels = {'0';'.1';'.2';'.3';'.4';'.5';'.6';'.7';'.8';'.9';'0';'.1';'.2';'.3';'.4';'.5';'.6';'.7';'.8';'.9';'0';'.1';'.2';'.3';'.4';'.5';'.6';'.7';'.8';'.9'};
elseif numParamCombinations == 6
    defind = 5; % Novelty 50
    numalphas=1;
    numrhos=6;
    labels = {'10';'20';'30';'40';'50';'60'};
end

params = 1:numParamCombinations;

%=== Determine best fixed training and test param.
[tmp, best_param_train] = min(mean([yData],2));
[tmp, best_param_test] = min(mean(yTest,2));

colours = {'b','g','r','m','k','y','c','b','g','r','c','m','y','k'};
symbols = {'.','o','x','s','*','+','d','v','^','<','>','p','h'};

global silentMain
if ~silentMain
    %==== Plot runlength for all instances - mean and std. 
    runlengths = [yTest];%, yTrain, yValid];
%    runlengths = [yTrain, yValid];
    means_runlength = mean(runlengths,2);
    
    std_runlength = std(runlengths,0,2);

    %=== Relative hardness. 
    min_runlength = min(runlengths);
    rel_runlength = runlengths-repmat(min_runlength,[size(runlengths,1),1]);
    means_rel_runlength = mean(rel_runlength,2);
    std_rel_runlength = std(rel_runlength,0,2);
    
    hold off
    fig_hand=figure(18);

    hold off
    legendstr = {};
    handles = [];
    for i=0:numalphas-1
        idx = i*numrhos+1:i*numrhos+numrhos;
        %            h=errorbar(params(idx),means_runlength(idx),std_runlength(idx), strcat(strcat(strcat(colours{i+1},symbols{i+1})),'-'), 'LineWidth', 2, 'MarkerSize', 9);
        h=errorbar(params(idx),means_rel_runlength(idx),std_rel_runlength(idx), strcat(strcat(strcat(colours{i+1},symbols{i+1})),'-'), 'LineWidth', 2, 'MarkerSize', 9);
        handles(end+1)=h;
        legendstr{end+1} = strcat('alpha = 1.', num2str(i+2));
        hold on
    end
    legend(handles, legendstr, 'Location', 'North', 'FontSize', 16);
    xlabel('rho', 'FontSize', 16);
    h=gca;
    set(h, 'XTick', 1:numalphas*numrhos)
    set(h,'XTickLabel',labels);
%        ylabel('Log median runlength (mean +/- std)', 'FontSize', 16);
%        title('Log median runlength vs. parameter combination', 'FontSize', 16)
    ylabel('Log overhead runlength (mean +/- std)', 'FontSize', 16);
    title('Overhead over optimal parameters per instance', 'FontSize', 16)

    fig_hand=figure(17);
    hold off
    legendstr = {};
    handles = [];
    for i=0:numalphas-1
        idx = i*numrhos+1:i*numrhos+numrhos;
        %            h=errorbar(params(idx),means_runlength(idx),std_runlength(idx), strcat(strcat(strcat(colours{i+1},symbols{i+1})),'-'), 'LineWidth', 2, 'MarkerSize', 9);
        h=errorbar(params(idx),means_runlength(idx),std_runlength(idx), strcat(strcat(strcat(colours{i+1},symbols{i+1})),'-'), 'LineWidth', 2, 'MarkerSize', 9);
        handles(end+1)=h;
        legendstr{end+1} = strcat('alpha = 1.', num2str(i+2));
        hold on
    end
    legend(handles, legendstr, 'Location', 'North', 'FontSize', 16)
    xlabel('rho', 'FontSize', 16);
    h=gca;
    set(h, 'XTick', 1:numalphas*numrhos)
    set(h,'XTickLabel',labels);
%        ylabel('Log median runlength (mean +/- std)', 'FontSize', 16);
%        title('Log median runlength vs. parameter combination', 'FontSize', 16)
    ylabel('Log runlength (mean +/- std)', 'FontSize', 16);
    title('Mean runlength across instances', 'FontSize', 16)

    %axis([0 17 1.5 5]) %uf
    %axis([0 17 2 5.5]) %bigmix
%        axis([0 17 4 7.5]) %sat
%        axis([0 17 0 2.5]) %sat
end

%set(fig_hand, 'FontUnit', 14);
% % 3D plot.
% %     runlengths = sum(runlengths,1);
% %     runlengths = reshape(runlengths, [4,4]);
% %     surfc(runlengths);
% %     xlabel('alpha');
% %     ylabel('rho');
% %     zlabel('log runlength');

%==== Pick interesting instances to plot.
min_actuals = min(yTest);
[tmp, minActualInd] = min(min_actuals);
max_actuals = max(yTest);
[tmp, maxActualInd] = max(max_actuals);

max_preds = max(yPred);
[tmp, maxPredInd] = max(max_preds);
min_preds = min(yPred);
[tmp, minPredInd] = min(min_preds);

avg_actuals = mean(yTest)';
[tmp, idx] = sort(avg_actuals,1);
q0_id = idx(1);
q025_id = idx(floor(nInstances*0.25)+1);
q05_id = idx(floor(nInstances*0.5)+1);
q075_id = idx(floor(nInstances*0.75)+1);
q1_id = idx(nInstances);

%plot_corr_pred_vs_actual_other_way(colours, symbols, 1:nInstances, yTest, yPred, numParamCombinations, 10, 2, 32, 1);
[cc_perinst, cc_perinst_std] = plot_corr_pred_vs_actual(colours, symbols, 1:nInstances, yTest, yPred, numParamCombinations, 10, 2, 30,1);
plot_corr_pred_vs_actual(colours, symbols, 1:nInstances, yTest, yPred, numParamCombinations, 10, 2, 31, 0);
if ~silentMain
    %===== Plot stuff for single instances.
    %colours = {'r','k','b','k','g','b','r','g','k','b','r','g','k','b','r','g'};
    %symbols = {'o','.','+','x','s','*','d','v','^','<','>','p','h'};
%    colours = {'k','b','r','g'};
%    symbols = {'o','*','x','s'};

    pickedInstances = unique([minActualInd, minPredInd, q025_id,q05_id, q075_id, maxPredInd, maxActualInd]) %bigmix. hardest actual=hardest pred
    %pickedInstances = [minActualInd, maxPredInd, q025_id, q05_id, maxActualInd] %uf. min actual= min pred
    %pickedInstances = [minActualInd, minPredInd, maxPredInd, q05_id, q1_id] %sat04

    
%    pickedInstances = 1:nInstances;

%    colours = {'r','k','b','k','g','b','r','g','k','b','r','g','k','b','r','g'};
%    symbols = {'o','.','+','x','s','*','d','v','^','<','>','p','h'};

    %==== Plot actual vs predicted runtime for some of the test set instances.
    plot_corr_pred_vs_actual(colours, symbols, pickedInstances, yTest, yPred, numParamCombinations, 9, 2, 2,0);
    plot_corr_pred_vs_actual(colours, symbols, pickedInstances, yTest, yPred, numParamCombinations, 10, 2, 3,1);

%    pickedInstances = pickedInstances(5)
    id = testInstanceIDs(1,pickedInstances)
    plot_pred_vs_actual_single(colours, symbols, pickedInstances, yTest, yPred, numParamCombinations, params, numalphas, numrhos, labels, 40);

    pickedInstances=1:nInstances;
    colours = {'k','k','k','k','k','k','k','k','k','k','k','k','k','k'};
    symbols = {'.','.','.','.','.','.','.','.','.','.','.','.','.','.'};
    [corr_pred_actual_mean, corr_pred_actual_std] = plot_corr_pred_vs_actual(colours, symbols, pickedInstances, yTest, yPred, numParamCombinations, 6, 1, 4, 1);
end

%===== Compute best runtime, supposedly best runtime, worst one, etc.
randomActuals = [];
worstActuals = [];
bestActuals = [];
bestFixedTrainParamActuals = [];
bestFixedTestParamActuals = [];
defActuals = [];
actualsSupposedlyBest = [];

for p=1:nInstances
	randperm_params = randperm(numParamCombinations);
    rand_param = randperm_params(1);
    randomActuals = [randomActuals, yTest(rand_param,p)];
    worstActuals = [worstActuals, max(yTest(:,p))];
    bestActuals = [bestActuals, min(yTest(:,p))];
    bestFixedTrainParamActuals = [bestFixedTrainParamActuals, yTest(best_param_train,p)];
    bestFixedTestParamActuals = [bestFixedTestParamActuals, yTest(best_param_test,p)];
    defActuals = [defActuals, yTest(defind,p)]; % default index.
    [tmp, supposedlyBestParams] = min(yPred(:,p));
    actualsSupposedlyBest = [actualsSupposedlyBest, yTest(supposedlyBestParams,p)];
end

if ~silentMain
    figure(10);
    hold off
%    for p=1:nInstances
%        line([bestActuals(p) worstActuals(p)], [actualsSupposedlyBest(p) actualsSupposedlyBest(p)], 'Color', 'k');
%        hold on
%    end

    plot(bestActuals, actualsSupposedlyBest, 'k.');
    hold on
    plot(worstActuals, actualsSupposedlyBest, 'rx');
    mini = min(min(bestActuals),min(actualsSupposedlyBest))-1;
    maxi = max(max(bestActuals),max(actualsSupposedlyBest))+1;
    line([mini maxi], [mini maxi]);
    title_str = sprintf('Automatic vs. best and worst'); %. Slowdown:%.2f, speedup:%.2f', mean(overhead),mean(speedup));
    title(title_str, 'FontSize', 16);
    xlabel('Log runtime[s], best/worst parameters', 'FontSize', 16);
    ylabel('Log runtime[s], automatic parameters', 'FontSize', 16);
    axis([mini maxi mini maxi])
end
    
%==== Compute stats.
cc = corrcoef(bestActuals,actualsSupposedlyBest);
if length(cc) > 1
    cc = cc(1,2);
end
speedup_over_best = (bestActuals-actualsSupposedlyBest); % will always be <= 0
speedup_over_worst = (worstActuals-actualsSupposedlyBest);
speedup_over_def = (defActuals-actualsSupposedlyBest);
speedup_over_best_train = (bestFixedTrainParamActuals-actualsSupposedlyBest);
speedup_over_best_test = (bestFixedTestParamActuals-actualsSupposedlyBest);
impr_over_best_fixed_test = mean(speedup_over_best_test);

bestFixedTestParamActuals-bestActuals;

if ~silentMain
%     fprintf('Instance set & best param train & best param test & Corr(actual, pred t) & loss over best  & s over worst    & s over def       & s over besttrain & s over besttest\n');
%     fprintf('~ & %d & %d & $%.2f \\pm %.2f$ & $%.2f \\pm %.2f$ & $%.2f \\pm %.2f$ & $%.2f \\pm %.2f$  & $%.2f \\pm %.2f$  & $%.2f \\pm %.2f$\n', ...
%         best_param_train, ...
%         best_param_test, ...
%         corr_pred_actual_mean,corr_pred_actual_std, ...
%         mean(loss_over_best),std(loss_over_best), ...
%         mean(speedup_over_worst),std(speedup_over_worst), ...
%         mean(speedup_over_def),std(speedup_over_def), ...
%         mean(speedup_over_best_train),std(speedup_over_best_train), ...
%         mean(speedup_over_best_test),std(speedup_over_best_test));
%     
    fprintf('Set & Algo & Gross corr & RMSE & Corr per inst. & best fixed a posteriori & s_{bpi} & s_{wpi} & s_{def} & s_{fixed}\n');
    fprintf('~ & ~ & %.2f & %.2f & $%.2f \\pm %.2f$ & %d & %.2f & %.2f & %.2f & %.2f\n', ...
        cc_all, rmse, corr_pred_actual_mean, corr_pred_actual_std, ...
        best_param_test, ...
        10^mean(speedup_over_best), ...
        10^mean(speedup_over_worst), ...
        10^mean(speedup_over_def), ...
        10^mean(speedup_over_best_test));
    

    scatter_plot(randomActuals,actualsSupposedlyBest, 'Log runtime[s], random parameters','Log runtime[s], automatic parameters','Automatic vs. random',9);
    scatter_plot(bestFixedTrainParamActuals,actualsSupposedlyBest, 'Log runtime[s], best fixed parameters on training set','Log runtime[s], automatic parameters','Automatic vs. best-fixed-on-training-set',11);
    scatter_plot(bestFixedTestParamActuals,actualsSupposedlyBest, 'Log runtime[s], best fixed a posteriori parameters','Log runtime[s], automatic parameters','Automatic vs. best-fixed-on-test-set',12);
    scatter_plot(defActuals,actualsSupposedlyBest, 'Log runtime[s], default parameters','Log runtime[s], automatic parameters','Automatic vs. default parameter setting',13);
end