function scatter_plot(X,Y,labelX,labelY,titleStr,figNo,Y_stddev)

Y_std = 0;
if nargin > 6, Y_std = Y_stddev;, end;
    
mini = max(min(X),min(Y))-1;
maxi = min(max(X),max(Y))+1;

figure(figNo)
hold off
plot(X, Y, 'k.', 'LineWidth', 2, 'MarkerSize', 12);
hold on
line([mini maxi], [mini maxi], 'LineWidth', 1)
if Y_std
    errorbar(X, Y, Y_std, 'r.', 'LineWidth', 2, 'MarkerSize', 12);
end
plot(X, Y, 'k.', 'LineWidth', 2, 'MarkerSize', 12);

rmse = sqrt(mean((X-Y).^2));
titleStr = strcat(strcat(titleStr, ', RMSE='),num2str(rmse));

global notitle
if notitle
    fprintf(titleStr)
else
    title(titleStr, 'FontSize', 16);
end
xlabel(labelX, 'FontSize', 16)
ylabel(labelY, 'FontSize', 16)
axis([mini maxi mini maxi])