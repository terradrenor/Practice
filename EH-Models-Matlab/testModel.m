function [rmse,cc,rmseReal] = testModel(modelFilename, xTest, yTest, specialIDs)

%========================================================================
% 1. Get predictions.
%========================================================================
[yPred, yPredStd] = predictTransformed(modelFilename, xTest);

%========================================================================
% 2. Some shallow evaluation.
%========================================================================
modelStruct = load(modelFilename);
transformation = modelStruct.transformation;
config = modelStruct.config;
yTestForPlot = transformResponse(transformation.responseTransformation, yTest);

uncertainty = 0;
if uncertainty
    [rmse,cc] = correlationPlot(yTestForPlot, yPred, yPredStd, 2, specialIDs, 1);
else
    [rmse,cc] = correlationPlot(yTestForPlot, yPred, yPredStd, 2, specialIDs);
end