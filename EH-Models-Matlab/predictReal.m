function [yPred, yPredStd] = predictReal(modelFilename, xTest)
%=== Reads the model of the modelfilename and uses it for predictions of the real runtime on xTest.

% Get predictions of transformed data.
[yPred, yPredStd] = predictTransformed(modelFilename, xTest)

% Compute inverse transform.
modelStruct = load(modelFilename);
model = modelStruct.model;
transformation = modelStruct.transformation;

yPred = inverseTransformResponse(transformation.responseTransformation, yPred);
yPredStd = inverseTransformResponse(transformation.responseTransformation, yPredStd);