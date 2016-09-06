%========================================================================
% 1. Configure parameters.
%========================================================================
fhConfiguration = 1;
if fhConfiguration
    config = getFrankConfiguration;
else
    config = getLinConfiguration;    
end

% % trainFilename = 'data/cv-var-nov-100-train.csv';
% % validFilename = 'data/cv-var-nov-100-valid.csv';
% % testFilename  = 'data/cv-var-nov-100-test.csv';
% % modelFilename = 'savedModels/cv-var-nov-100-linearModel';

trainFilename = 'data/practice-100-train.csv';
validFilename = 'data/practice-100-valid.csv';
testFilename  = 'data/practice-100-test.csv';
modelFilename = 'savedModels/practice-100-model';

% trainFilename = 'data/sat04-additional-1000inst-novelty+-r1-train.csv';
% validFilename = 'data/sat04-additional-1000inst-novelty+-r1-valid.csv';
% testFilename  = 'data/sat04-orig-100inst-novelty+-r10.csv';
% modelFilename = 'savedModels/sat04-additional-1000inst-novelty+-linearModel';
% 
% trainFilename = 'data/sat04-add-nov-10-def-train.csv';
% validFilename = 'data/sat04-add-nov-10-def-valid.csv';
% testFilename  = 'data/sat04-add-nov-10-def-test.csv';
% %testFilename  = 'data/sat04-orig-nov-10-def.csv';
% 

%%%%%%%%%%%%%%%%%%%%%%%%% UNSTRUCTURED INSTANCES %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 1c in CP06.
% CC 0.903/0.911, RMSE 0.37/0.35
% trainFilename = 'data/cv_var-feasSAPS-n4976-single-train__saps_def__1__900.0.csv';
% validFilename = 'data/cv_var-feasSAPS-n2488-single-valid__saps_def__1__900.0.csv';
% testFilename =  'data/cv_var-feasSAPS-n2488-single-test__saps_def__1__900.0.csv';
% modelFilename = 'savedModels/cv_var-feasSAPS-saps_def_1';

% % CC 0.960/0.968, RMSE 0.23/0.20 
% trainFilename = 'data/cv_var-feasSAPS-n4976-single-train__saps_def__10__900.0.csv';
% validFilename = 'data/cv_var-feasSAPS-n2488-single-valid__saps_def__10__900.0.csv';
% testFilename =  'data/cv_var-feasSAPS-n2488-single-test__saps_def__10__900.0.csv';
% modelFilename = 'savedModels/cv_var-feasSAPS-saps_def';

% CC 0.967/0.977, RMSE 0.21/0.17
% trainFilename = 'data/cv_var-feasSAPS-n4976-single-train__saps_def__100__900.0.csv';
% validFilename = 'data/cv_var-feasSAPS-n2488-single-valid__saps_def__100__900.0.csv';
% testFilename =  'data/cv_var-feasSAPS-n2488-single-test__saps_def__100__900.0.csv';
% modelFilename = 'savedModels/cv_var-feasSAPS-saps_def_100';

% CC 0.968/0.978, RMSE 0.20/0.17
% trainFilename = 'data/cv_var-feasSAPS-n4976-single-train__saps_def__1000__900.0.csv';
% validFilename = 'data/cv_var-feasSAPS-n2488-single-valid__saps_def__1000__900.0.csv';
% testFilename =  'data/cv_var-feasSAPS-n2488-single-test__saps_def__1000__900.0.csv';
% modelFilename = 'savedModels/cv_var-feasSAPS-saps_def_1000';


% quad: CC=0.800, RMSE=0.42
% trainFilename = 'data/cv_fix-feasSAPS-n5062-single-train__saps_def__100__900.0.csv';
% validFilename = 'data/cv_fix-feasSAPS-n2531-single-valid__saps_def__100__900.0.csv';
% testFilename =  'data/cv_fix-feasSAPS-n2531-single-test__saps_def__100__900.0.csv';
% modelFilename = 'savedModels/cv_fix-feasSAPS-saps_def_100';


% % CC 0.947/0.952, RMSE 0.25/0.23 
% trainFilename = 'data/cv_var-feasSAPS-n4976-single-train__nov+_def__10__900.0.csv';
% validFilename = 'data/cv_var-feasSAPS-n2488-single-valid__nov+_def__10__900.0.csv';
% testFilename =  'data/cv_var-feasSAPS-n2488-single-test__nov+_def__10__900.0.csv';
% modelFilename = 'savedModels/cv_var-feasSAPS-nov+_def';
% 
% quad: CC=0.878, RMSE=0.37
% Figure 1a in CP06.
% trainFilename = 'data/cv_var-feasSAPS-n4976-single-train__nov+_def__1__900.0.csv';
% validFilename = 'data/cv_var-feasSAPS-n2488-single-valid__nov+_def__1__900.0.csv';
% testFilename =  'data/cv_var-feasSAPS-n2488-single-test__nov+_def__1__900.0.csv';
% modelFilename = 'savedModels/cv_var-feasSAPS-nov+_def_1';

% quad: 
%Figure 1b in CP06.
% trainFilename = 'data/cv_var-feasSAPS-n4976-single-train__nov+_def__100__900.0.csv';
% validFilename = 'data/cv_var-feasSAPS-n2488-single-valid__nov+_def__100__900.0.csv';
% testFilename =  'data/cv_var-feasSAPS-n2488-single-test__nov+_def__100__900.0.csv';
% modelFilename = 'savedModels/cv_var-feasSAPS-nov+_def_100';

% % CC 0.765/0.781, RMSE 0.46/0.44
% trainFilename = 'data/cv_fix-feasSAPS-n5062-single-train__saps_def__10__900.0.csv';
% validFilename = 'data/cv_fix-feasSAPS-n2531-single-valid__saps_def__10__900.0.csv';
% testFilename =  'data/cv_fix-feasSAPS-n2531-single-test__saps_def__10__900.0.csv';
% modelFilename = 'savedModels/cv_fix-feasSAPS-saps_def';
% 
% % CC 0.586/0.603, RMSE 0.61/0.60
% trainFilename = 'data/cv_fix-feasSAPS-n5062-single-train__nov+_def__10__900.0.csv';
% validFilename = 'data/cv_fix-feasSAPS-n2531-single-valid__nov+_def__10__900.0.csv';
% testFilename =  'data/cv_fix-feasSAPS-n2531-single-test__nov+_def__10__900.0.csv';
% modelFilename = 'savedModels/cv_fix-feasSAPS-nov+_def';
% 
% % CC 0.933/0.938, RMSE 0.52/0.50
% trainFilename = 'data/sat04add-feasSAPS-n734-single-train__saps_def__10__900.0.csv';
% validFilename = 'data/sat04add-feasSAPS-n367-single-valid__saps_def__10__900.0.csv';
% testFilename =  'data/sat04add-feasSAPS-n367-single-test__saps_def__10__900.0.csv';
% modelFilename = 'savedModels/sat04_additional-feasSAPS-saps_def';
% 
% % CC 0.934/0.938, RMSE 0.58/0.56
% trainFilename = 'data/sat04add-feasSAPS-n734-single-train__nov+_def__10__900.0.csv';
% validFilename = 'data/sat04add-feasSAPS-n367-single-valid__nov+_def__10__900.0.csv';
% testFilename =  'data/sat04add-feasSAPS-n367-single-test__nov+_def__10__900.0.csv';
% modelFilename = 'savedModels/sat04_additional-feasSAPS-nov+_def';
% 
% %%%%%%%%%%%%%%%%%%%%%%%%% STRUCTURED INSTANCES %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % CC 0.988/0.995, RMSE 0.33/0.21
% % Figure 2a in CP06.
% trainFilename = 'data/QWHrand-feasSAPS-n4024-single-train__saps_def__10__900.0.csv';
% validFilename = 'data/QWHrand-feasSAPS-n2012-single-valid__saps_def__10__900.0.csv';
% testFilename =  'data/QWHrand-feasSAPS-n2012-single-test__saps_def__10__900.0.csv';
% modelFilename = 'savedModels/QWHrand-feasSAPS-saps_def';
% 
% % CC 0.988/0.992, RMSE 0.22/0.18
% trainFilename = 'data/QWHrand-feasSAPS-n4024-single-train__nov+_10__10__900.0.csv';
% validFilename = 'data/QWHrand-feasSAPS-n2012-single-valid__nov+_10__10__900.0.csv';
% testFilename =  'data/QWHrand-feasSAPS-n2012-single-test__nov+_10__10__900.0.csv';
% modelFilename = 'savedModels/QWHrand-feasSAPS-nov+_10';
% 
% % CC 0.995/0.997, RMSE 0.17/0.15
% Figures 3a, 3b, and 3c in CP06.
% trainFilename = 'data/QCP-feasSAPS-n7631-single-train__saps_def__10__900.0.csv';
% validFilename = 'data/QCP-feasSAPS-n3815-single-valid__saps_def__10__900.0.csv';
% testFilename =  'data/QCP-feasSAPS-n3815-single-test__saps_def__10__900.0.csv';
% modelFilename = 'savedModels/QCP-feasSAPS-saps_def';
% 
% % Bayesian plots.
% testFilename =  'data/QWHrand-feasSAPS-n2012-single-test__saps_def__10__900.0.csv';


% % % CC 0.993/994, RMSE 0.12/0.11
% % % Figure 2c in CP06.
% trainFilename = 'data/QCP-feasSAPS-n7631-single-train__nov+_10__10__900.0.csv';
% validFilename = 'data/QCP-feasSAPS-n3815-single-valid__nov+_10__10__900.0.csv';
% testFilename =  'data/QCP-feasSAPS-n3815-single-test__nov+_10__10__900.0.csv';
% modelFilename = 'savedModels/QCP-feasSAPS-nov+_10';
% 
% %Bayesian plots trained on QCP
% testFilename =  'data/QWHrand-feasSAPS-n2012-single-test__nov+_10__10__900.0.csv';
% %modelFilename = 'savedModels/QCP-feasSAPS-nov+_10_gp_seiso_1000datapoints';
% modelFilename = 'savedModels/QCP-feasSAPS-nov+_NetlabBLR';


% % CC 0.890/0.892, RMSE 0.45/0.45
% % Figure 2b in CP06.
% trainFilename = 'data/SW_GCP-feasSAPS-n2786-single-train__saps_def__10__900.0.csv';
% validFilename = 'data/SW_GCP-feasSAPS-n1393-single-valid__saps_def__10__900.0.csv';
% testFilename =  'data/SW_GCP-feasSAPS-n1393-single-test__saps_def__10__900.0-without1299.csv'; %entry 1299 with INSTANCE ID had a bogeous entry of 0.93 for column saps_BestSolution_CoeffVariance that threw off everything! (predicted to take 10^-5 seconds, but takes > 900s)
% modelFilename = 'savedModels/SW_GCP-feasSAPS-saps_def';
% 
% % CC 0.690/0.691, RMSE 0.23/0.23
% trainFilename = 'data/SW_GCP-feasSAPS-n2786-single-train__nov+_10__10__900.0.csv';
% validFilename = 'data/SW_GCP-feasSAPS-n1393-single-valid__nov+_10__10__900.0.csv';
% testFilename =  'data/SW_GCP-feasSAPS-n1393-single-test__nov+_10__10__900.0.csv';
% modelFilename = 'savedModels/SW_GCP-feasSAPS-nov+_10';

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
rtd = 0;

ids = [];
if rtd
    %rtdFilenames = {'QCP-saps_def_q10inst-runtimes', 'QCP-saps_def_q25inst-runtimes', 'QCP-saps_def_q50inst-runtimes', 'QCP-saps_def_q75inst-runtimes', 'QCP-saps_def_q90inst-runtimes'};
    %ids = [56369, 48372, 50779, 48897, 30918];
    rtdFilenames = {'QCP-saps_def_q25inst-runtimes', 'QCP-saps_def_q75inst-runtimes'};
    ids = [48372, 48897];
end
modelStruct = load(modelFilename);
config = modelStruct.config;

%========================================================================
% 3.1 Read in data.
%========================================================================
[testInstanceIDs, namesY, namesX, yTest, cappedTest, solutionTest, xTest] = readRawData(testFilename, config.numOutputs, config.selectedOutput, config.removeCapped);

%========================================================================
% 3.2 Test model.
%========================================================================
if rtd
    %=== Read in runtimes
    for i=1:length(rtdFilenames)
        runtimes = load(rtdFilenames{i});
        id = ids(i);
        index = find(testInstanceIDs==id);
        xTestID = xTest(index,:);
        yPred = predictReal(modelFilename, xTestID);
        numPoints = length(runtimes);
        prob = 1.0/numPoints:1.0/numPoints:1;
        figure(i+2)
        hold off
        handles = [];
        legendstr = {};
        h=semilogx(runtimes, prob, 'b-');
        handles(end+1) = h;
        legendstr{end+1} = 'True empirical RTD';
        hold on
        
        runtimes = [(min(runtimes)/100:min(runtimes)/100:min(runtimes))'; runtimes; (max(runtimes):max(runtimes)/10:max(runtimes)*10)'];
        y = 1-2.^(-runtimes/yPred);
        h=semilogx(runtimes, y, 'r--');
        handles(end+1) = h;
        legendstr{end+1} = 'Predicted empirical RTD';
        legend(handles, legendstr, 'Location', 'NorthWest');
        xlabel('Runtime [seconds]');
        ylabel('Probability of success');
        title(rtdFilenames{i});
    end
else
    specialIDs = [];
    for i=1:length(ids)
        specialIDs = [specialIDs, find(testInstanceIDs==ids(i))];
    end
    [rmse,cc] = testModel(modelFilename, xTest, yTest, specialIDs)
end