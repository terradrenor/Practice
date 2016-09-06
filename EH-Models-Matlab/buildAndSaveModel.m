function [transformation, model] = buildAndSaveModel(data, config, modelFilename)
% Builds and saves a model for some data in the struct data using ML 
% techniques specified in the struct config.
% The data struct is required to at least have the fields xTrain and
% yTrain, xValid and yValid.

%========================================================================
% 1. Transform raw data into nice data for ML and remember the
%    transformation.
%========================================================================
transformation = buildCleanData(data, config);
transformation.removeCapped = config.removeCapped;

%========================================================================
% 2. Apply transformation to the raw data.
%========================================================================
[xFinal] = formatData(data.xTrain, transformation);
yFinal = transformResponse(transformation.responseTransformation, data.yTrain);

%========================================================================
% 3. Build model.
%========================================================================
model = learnModel(xFinal, yFinal, config.modelType);

%========================================================================
% 4. Save model. If we know the IDs used for training and validation
%    we also save them for future reference.
%========================================================================
% Save ys for later evaluation of autoparam (as baseline best train param)
yData = [data.yTrain; data.yValid];
if isfield(data, 'trainIDs') and isfield(data, 'validIDs')
    dataIDs.trainIDs = trainIDs;
    dataIDs.validIDs = validIDs;
    save (modelFilename, 'model', 'transformation', 'config', 'yData', 'dataIDs');
else
    save (modelFilename, 'model', 'transformation', 'config', 'yData');
end