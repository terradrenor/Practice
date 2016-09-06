function [scale, bias] = determine_transformation(xTrain,trafo)

if nargin <= 1
    trafo = 1;
end

[N, dim] = size(xTrain);

% normalize data w.r.t. training data.
bias = zeros(1,dim);
scale = zeros(1,dim);

%trafo = 1; % mean 0, std=1
%trafo = 2; % between 0 and 1.
%trafo = 3; % no normalization.

for i=1:dim
    if trafo == 1
        bias(i) = mean(xTrain(:,i));
    elseif trafo == 2
        bias(i) = min(xTrain(:,i));
    else
        bias(i) = 0;
    end

    %=== Subtract bias.
    xTrain(:,i) = xTrain(:,i) - bias(i);
    
    if trafo == 1
        scale(i) = std(xTrain(:,i));
    elseif trafo == 2
        scale(i) = max(xTrain(:,i));
    else
        if(max(xTrain(:,i)) < min(xTrain(:,i)) + 1e-10)
            scale(i) = 0;
        else
            scale(i) = 1;
        end
    end
end