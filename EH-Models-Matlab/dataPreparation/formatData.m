function [xData, yData] = formatData(xData, transformation)

%=== Remove constant features.
xData = xData(:,transformation.kept_columns);

%=== Split into parameters and instance features.
paramsData = xData(:,1:transformation.numParams);
xData = xData(:,transformation.numParams+1:end);

%=== Normalize data for PCA.
xData = (xData - repmat(transformation.bias1, [size(xData,1),1])) ./ repmat(transformation.scale1, [size(xData,1),1]);

%=== PCA.
xData = xData*transformation.pcVec;

%=== Feature selection for linear instance features.
xData = xData(:,transformation.linearFeatureIndices);

%=== Build basis functions.
%=== For data without parameters, this may include building quadratic features etc.
%=== For data with parameters, it also builds combinations of parameters and instance features.
[xData, transformation.namesX] = buildBasisFunctions(paramsData, xData, transformation.namesParams, transformation.namesX, transformation.doQuadratic);

%=== Normalize data again.
xData = (xData - repmat(transformation.bias2, [size(xData,1),1])) ./ repmat(transformation.scale2, [size(xData,1),1]);

%=== Final feature selection to build small model.
finalFeatureIndices = transformation.setOfFinalFeatureIndices{transformation.bestIndexForFinalFeatures};
xData = xData(:,finalFeatureIndices);