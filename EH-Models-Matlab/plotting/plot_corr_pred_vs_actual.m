function [cc, stdcc] = plot_corr_pred_vs_actual(colours, symbols, pickedInstances, yTest, yPred, numdiff, markerSize, lineWidth, figNo, perinst)
global silentMain
yTest = yTest(:,pickedInstances);
yPred = yPred(:,pickedInstances);

[D, N] = size(yTest);
yTest = reshape(yTest, [numdiff, D*N/numdiff]);
yPred = reshape(yPred, [numdiff, D*N/numdiff]);

[numdiff, N] = size(yTest);

%==== Compute correlation coefficient per instance and plot instance runtimes.
if ~silentMain
    figure(figNo);
    hold off
end

predflat = yPred(:);
testflat = yTest(:);
good_ind = 1:length(predflat);
%good_ind = find(testflat<2.95);

rmse = sqrt(mean( (predflat(:)-testflat(:)).^2 ));
%rmse = sqrt(mean( (yPred(:)-yTest(:)).^2 ));
if perinst
    corrcoefs = zeros(N,1);
    for p=1:N
        kmod1 = mod(p-1,length(colours))+1;
        kmod2 = mod(p-1,length(symbols))+1;
        if ~silentMain
            h=plot(yTest(:,p), yPred(:,p), strcat(strcat(colours{kmod1},symbols{kmod2})), 'MarkerSize', markerSize, 'LineWidth', lineWidth);
            hold on
        end
        test = yTest(:,p);
        pred = yPred(:,p);
%        goodind = find(test<2.95)
%        test=test(goodind)
%        pred=pred(goodind)
        cc = corrcoef(pred,test);
        if(length(cc)>1) cc = cc(1,2);end
        corrcoefs(p) = cc;
        
%        cc = corrcoef(yPred(:,p),yTest(:,p));
        if(length(cc)>1) cc = cc(1,2);end
        corrcoefs(p) = cc;
    end
    cc = mean(corrcoefs);
    stdcc = std(corrcoefs);
    title_str = sprintf('Corrcoeff per inst = %.2f +/- %.2f, RMSE = %.2f',cc,stdcc,rmse); %Actual vs. predicted log runlength, 
%    fprintf(strcat(title_str, 'numdiff=%f\n'),numdiff)
else
    cc = corrcoef(predflat,testflat);
%    cc = corrcoef(yPred,yTest);
    cc = cc(1,2);
    stdcc = 0;
    if ~silentMain
        h=plot(yTest, yPred, 'k.', 'MarkerSize', markerSize, 'LineWidth', lineWidth);
    end
    title_str = sprintf('Corrcoeff = %.2f, RMSE = %.2f',cc,rmse); %Actual vs. predicted log runlength,
end

if ~silentMain
    mini = min(min(min(yPred)),min(min(yTest)))-1;
    maxi = max(max(max(yPred)),max(max(yTest)))+1;
    line([mini maxi], [mini maxi]);
    
    global notitle
    if notitle
        fprintf(title_str)
    else
        title(title_str, 'FontSize', 16)
    end
    
    xlabel('Actual log10 runtime [seconds]', 'FontSize', 16)
    ylabel('Predicted log10 runtime [seconds]', 'FontSize', 16)
    axis([mini+0.7 maxi-0.7 mini+0.7 maxi-0.7])
%    get(h)
%    set(h,'width',4)
%    set(h,'heigth',4)
    %axis([2.4 3.5 2.4 3.5])
    %line([2.4 3.5], [2.4 3.5])
    %axis([2 4.5 2 4.5])
end