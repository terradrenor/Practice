function data = readData(trainFilename, validFilename, numOutputs, selectedOutput, removeCapped)

[trainInstanceIDs, namesY, namesX, yTrain, cappedTrain, solutionTrain, xTrain] = readRawData(trainFilename, numOutputs, selectedOutput, removeCapped);
[validInstanceIDs, namesY, namesX, yValid, cappedValid, solutionValid, xValid] = readRawData(validFilename, numOutputs, selectedOutput, removeCapped);

%=== Required fields.
data.xTrain = xTrain;
data.xValid = xValid;
data.yTrain = yTrain;
data.yValid = yValid;

%=== Additional fields.
data.cappedTrain = cappedTrain;
data.cappedValid = cappedValid;
data.solutionTrain = solutionTrain;
data.solutionValid = solutionValid;
data.trainInstanceIDs = trainInstanceIDs;
data.validInstanceIDs = validInstanceIDs;
