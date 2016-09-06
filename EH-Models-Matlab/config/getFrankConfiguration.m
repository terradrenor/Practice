function configuration = getFrankConfiguration()

%=== Parameters of input file.
configuration.numOutputs = 3;
configuration.selectedOutput = 3;
configuration.numParams = 0;
configuration.removeCapped = 1;


%=== Parameters of transformation.
configuration.responseTransformation = 'log10';
configuration.linearSize = 50;
configuration.doQuadratic = 1;
configuration.maxModelSize = 40;
configuration.numPcaComponents = 0; %(set to 0: PCA turned off)
configuration.modelType = 'BLR';%'Netlab-BLR';%'BLR'; %'GP-SEard'; %'GP-SEiso'; %'GP-M3iso'; %'GP-M5iso'

global silent
silent = 0;