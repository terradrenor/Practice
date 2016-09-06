%========================================================================
% 1. Configure parameters.
%========================================================================
fhConfiguration = 1;
if fhConfiguration
    config = getFrankConfiguration;
else
    config = getLinConfiguration;    
end

config.doQuadratic = 0;

novelty=0;
if novelty
    config.numParams = 2;
    config.numParamCombinations = 6;

    trainFilename = 'data/sat04-add-nov-10-train.csv';
    validFilename = 'data/sat04-add-nov-10-valid.csv';
    testFilename  = 'data/sat04-orig-nov-10.csv';

    trainFilename = 'data/sat04-add-nov-10-train.csv';
    validFilename = 'data/sat04-add-nov-10-valid.csv';
    testFilename  = 'data/sat04-add-nov-10-test.csv';
    testFilename  = 'data/sat04-orig-nov-10.csv';
    modelFilename = 'savedModels/sat04-additional-1000inst-novelty+-linearModel';
    
    %%%%%%%%%%%%%%%%%%  Novelty+  %%%%%%%%%%%%%%%%%
    trainFilename = 'sat04add-feasSAPS-n500-param-train__nov+_all__1__900.0.csv';
    validFilename = 'sat04add-feasSAPS-n500-param-valid__nov+_all__1__900.0.csv';
%    testFilename  = 'sat04add-feasSAPS-n150-param-test__nov+_all__10__900.0.csv';
    testFilename  = 'sat04orig-feasSAPS__nov+_all__10__900.0.csv';
    modelFilename = 'savedModels/sat04add__nov__2nd_order';
   
    trainFilename = 'QWHrand-feasSAPS-n500-param-train__nov+_all__1__900.0.csv';
    validFilename = 'QWHrand-feasSAPS-n500-param-valid__nov+_all__1__900.0.csv';
    testFilename  = 'QWHrand-feasSAPS-n150-param-test__nov+_all__10__900.0.csv';
    modelFilename = 'savedModels/QWHrand__nov__2nd_order';
    
    trainFilename = 'QWHrand_AND_sat04add-feasSAPS-n500-param-train__nov+_all__1__900.0.csv';
    validFilename = 'QWHrand_AND_sat04add-feasSAPS-n500-param-valid__nov+_all__1__900.0.csv';
    testFilename  = 'QWHrand_AND_sat04orig-feasSAPS-n150-param-test__nov+_all__10__900.0.csv';
    modelFilename = 'savedModels/QWHrand_AND_sat04orig__nov__2nd_order';
else
    config.numParams = 4;
    config.numParamCombinations = 30;

    %%%%%%%%%%%%%%%%%%  SAPS  %%%%%%%%%%%%%%%%%

    trainFilename = 'sat04add-feasSAPS-n500-param-train__saps_all__1__900.0.csv';
    validFilename = 'sat04add-feasSAPS-n500-param-valid__saps_all__1__900.0.csv';
    %    testFilename  = 'sat04add-feasSAPS-n150-param-test__saps_all__10__900.0.csv';
% Figure 4b in CP06.
    testFilename  = 'sat04orig-feasSAPS__saps_all__10__900.0.csv';
modelFilename = 'savedModels/sat04additional-param_saps_all-2nd_order';

%    testFilename = 'sat04orig_medianID__saps_all__1000__900.0.csv';
%    modelFilename = 'sat04-additional-param_saps_all-4th_order';

% Figure 4c in CP06.
%    testFilename = 'sat04orig_detailed_instanceID__saps_all__1000__900.0.csv';

% Figure 4a in CP06.
%     trainFilename = 'data/QWHrand-feasSAPS-n500-param-train__saps_all__1__900.0.csv';
%     validFilename = 'data/QWHrand-feasSAPS-n500-param-valid__saps_all__1__900.0.csv';
%     testFilename  = 'data/QWHrand-feasSAPS-n150-param-test__saps_all__10__900.0.csv';
%     modelFilename = 'savedModels/QWHrand-param_saps_all-2nd_order';
% 
%     trainFilename = 'QWHrand_AND_sat04additional-feasSAPS-n500-param-train__saps_all__1__900.0.csv';
%     validFilename = 'QWHrand_AND_sat04additional-feasSAPS-n500-param-valid__saps_all__1__900.0.csv';
%     testFilename  = 'QWHrandtest_AND_sat04orig-feasSAPS__150each__saps_all__10__900.0.csv';
%     modelFilename = 'savedModels/QWHrandtest_AND_sat04orig-2nd_order';
end
config.removeCapped = 0; % Can't remove capped here, so we have a data point for each parameter
% setting.
%========================================================================
% 2.1 Read in data and put it into a data structure.
%========================================================================
data = readData(trainFilename, validFilename, config.numOutputs, config.selectedOutput, config.removeCapped);

%========================================================================
% 2.2 Build a model.
%========================================================================
[transformation, model] = buildAndSaveModel(data, config, modelFilename);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TEST - can't use anything but the saved model and testFilename.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

modelStruct = load(modelFilename);
config = modelStruct.config;
%========================================================================
% 3.1 Read in data.
%========================================================================
[testInstanceIDs, namesY, namesX, yTest, cappedTest, solutionTest, xTest] = readRawData(testFilename, config.numOutputs, config.selectedOutput, 0);
% Can't remove capped here, so we have a data point for each parameter
% setting.

%========================================================================
% 3.2 Test model.
%========================================================================
global silentMain
silentMain = 0
testParametricModel(modelFilename, xTest, yTest, testInstanceIDs)

