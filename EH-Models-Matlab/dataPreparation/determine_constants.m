function constants = determine_constants(xTrain)

maxX = max(xTrain,[],1);
minX = min(xTrain,[],1);

diffX = maxX-minX;
constants = find(diffX <= 1e-10);

fprintf('Discarding %i constant features of %i in total.\n', length(constants), size(xTrain,2));