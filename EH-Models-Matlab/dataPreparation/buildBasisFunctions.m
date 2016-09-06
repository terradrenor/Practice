function [Phi, names, featureIndices] = buildBasisFunctions(xParams, X, namesParams, namesX, square)

numParams = size(xParams,2);

%=== Square parameters.
%[xParams, namesParams] = squareData(xParams, namesParams);
%%[xParams, namesParams] = fh_squareData(xParams, namesParams);
[xParams, namesParams] = squareData(xParams, namesParams);
fullX = [xParams, X];
fullNames = [namesParams; namesX];

numParams = size(xParams,2);

pack; %stores stuff in contiguous blocks -> to counter memory problems ...
if square
    %=== Square everything (again).
    [Phi, names] = squareData(fullX, fullNames);
else
    [Phi, names] = combineParamsAndFeats(fullX, fullNames, numParams);
%    Phi = fullX;
%    names = fullNames;
end
fprintf('Constructed %i basis functions.\n', size(Phi,2));