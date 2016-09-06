function parametricCorrelationPlot(instances, pickedInstanceIDs, cc, stdcc, rmse, figNo);
% Plot a figure in which each instance gets its own symbol and colour.
% instances is a hashtable instances{id} = cell array of structs
% with xTest and yTest.

colours = {'b','g','r','m','k','y','c','b','g','r','c','m','y','k'};
symbols = {'.','o','x','s','*','+','d','v','^','<','>','p','h'};

%==== Get the boundaries for the plot. Code duplication b/c I have to
%     plot the line first, so it's in the background.
inst_keys = keys(instances);
mini = 1e100;
maxi = -1;
for i=1:length(pickedInstanceIDs)
    entry = get(instances, pickedInstanceIDs(i));
    yTests = [];
    yPreds = [];
    for j=1:length(entry)
        yTests(j) = entry{j}.yTest;
        yPreds(j) = entry{j}.yPred;
    end
    mini = min([yPreds,yTests,mini]);
    maxi = max([yPreds,yTests,maxi]);
end

%==== Create the line that perfect predictions lie on.
figure(figNo);
hold off
line([mini-1 maxi+1],[mini-1 maxi+1])
hold on

%=== Plot the data.
inst_keys = keys(instances);
for n=1:length(pickedInstanceIDs)
    entry = get(instances, pickedInstanceIDs(n));
    yTests = [];
    yPreds = [];
    for j=1:length(entry)
        yTests(j) = entry{j}.yTest;
        yPreds(j) = entry{j}.yPred;
    end

    kmod1 = mod(n-1,length(colours))+1;
    kmod2 = mod(n-1,length(symbols))+1;
    h=plot(yTests, yPreds, strcat(strcat(colours{kmod1},symbols{kmod2})), 'MarkerSize', 5, 'LineWidth', 3);
end
title_str = sprintf('CC per inst = %.3f +/- %.3f, RMSE = %.2f',cc,stdcc,rmse); %Actual vs. predicted log runlength,
title(title_str, 'FontSize', 16)

xlabel('Actual log10 runtime [seconds]', 'FontSize', 16)
ylabel('Predicted log10 runtime [seconds]', 'FontSize', 16)
axis([mini-0.5 maxi+0.5 mini-0.5 maxi+0.5])