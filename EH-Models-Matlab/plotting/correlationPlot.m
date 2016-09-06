function [rmse, cc] = correlationPlot(yTest, yPred, yPredStd, figNo, specialIDs, uncertainty)
%yTest and yPred are Nx1 vectors.
% specialIDs gives indices of special points that should be plotted with
% emphasis (big, red crosses)

%=== Deal with inputs.
if nargin < 5
    specialIDs = [];
end
if nargin < 6
    uncertainty = 0;
end

%=== Compute statistics.
rmse = sqrt(mean((yPred-yTest).^2));
cc = corrcoef(yPred,yTest);
cc = cc(1,2);
stdcc = 0;

global silent;
if ~silent
    %==== Create the line that perfect predictions lie on.
    mini = min(min(min(yPred)),min(min(yTest)))-1;
    maxi = max(max(max(yPred)),max(max(yTest)))+1;

    figure(figNo);
    hold off
    line([mini maxi],[mini maxi])
    hold on

    %=== Compute quantiles of the data.
    ySorted = sort(yTest);
    q010 = ySorted(floor(length(yTest)/10.0*1));
    h=line([q010, q010],[mini, maxi]);
    set(h,'Color','r');
    set(h,'LineStyle','--');

    q050 = ySorted(floor(length(yTest)/10.0*5));
    quantil05 = find(yTest==q050);
    h=line([q050, q050],[mini, maxi]);
    set(h,'Color','r');
    set(h,'LineStyle','--');

    q090 = ySorted(floor(length(yTest)/10.0*9));
    quantil09 = find(yTest==q090);
    h=line([q090, q090],[mini, maxi]);
    set(h,'Color','r');
    set(h,'LineStyle','--');    

    %=== Plot the data.
    if uncertainty
        rand('state',42);
        yAdd = yPredStd;
        randints = randperm(length(yTest));
        toplot = randints(1:500);
        yTest = yTest(toplot);
        yPred = yPred(toplot);
        yAdd  = yAdd(toplot);        
        h=errorbar(yTest, yPred, yAdd, 'k.');
        h=plot(yTest, yPred, 'r.', 'MarkerSize', 5, 'LineWidth', 3);
    else
        h=plot(yTest, yPred, 'k.', 'MarkerSize', 5, 'LineWidth', 3);
    end
    plot(yTest(specialIDs), yPred(specialIDs), 'rx', 'MarkerSize', 15, 'LineWidth', 3);

    %=== Label the plot.
    title_str = sprintf('Corrcoeff = %.3f, RMSE = %.2f',cc,rmse); %Actual vs. predicted log runlength,
    title(title_str, 'FontSize', 16)
 
    xlabel('Actual log10 runtime [seconds]', 'FontSize', 16)
    ylabel('Predicted log10 runtime [seconds]', 'FontSize', 16)
    axis([mini+0.1 maxi-0.1 mini+0.1 maxi-0.1])
end