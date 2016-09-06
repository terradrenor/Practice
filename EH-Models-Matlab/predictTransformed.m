function [yPred, yPredStd] = predictTransformed(modelFilename, xTest)
%=== Reads the model of the modelfilename and uses it for predictions on xTest.

modelStruct = load(modelFilename);
model = modelStruct.model;
transformation = modelStruct.transformation;

%========================================================================
% 1. Apply transformation.
%========================================================================
[xTestFinal] = formatData(xTest, transformation);

%========================================================================
% 2. Apply model.
%========================================================================
[yPred, yPredStd] = applyModel(model, xTestFinal);