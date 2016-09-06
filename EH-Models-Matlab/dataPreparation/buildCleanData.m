function transformation = buildCleanData(data, c)
% This takes as inputs the raw data xTrain, xValid, yTrain, yValid
% available at training time as well as the names of X and the number
% of parameters. Also some parameters for feature selection.
% It then does the following:
% 1. Determine constant columns in xTrain,
%    remove them from xTrain, xValid, xTest, and namesX.
%    Decrease numparams if one or more of them are constants.
% 2. Split Xs and names into parameters and features
% 3. Call Lin's feature selection code to select the most informative
%    features (no params involved yet)
% 4. Combine these important features with the parameters
% 5. Normalize combinations w.r.t. the training data
% 6. Again, call feature selection software by KLB to select the
%    most informative combined features
%    (this 2-way process is necessary since memory otherwise explodes)
% 7. Transformation of the response variable Y, e.g. log10
% 8. Return now hopefully clean features and response.

xTrain = data.xTrain;
xValid = data.xValid;
yTrain = data.yTrain;
yValid = data.yValid;
if isfield(data, 'namesX')
    namesX = data.namesX;
else
    namesX = cell(size(xTrain,2),1);
    for i=1:length(namesX)
        namesX{i} = 'noname';
    end
end

numParams = c.numParams;
transformation.doQuadratic = c.doQuadratic;

% 1. Transformation of the response variable Y, e.g. log10
yTrain = transformResponse(c.responseTransformation, yTrain);
yValid = transformResponse(c.responseTransformation, yValid);
transformation.responseTransformation = c.responseTransformation;

% 2. Determine constant columns in xTrain,
%    remove them from xTrain, xValid, xTest, and namesX.
%    Decrease numparams if one or more of them are constants.
constants = determine_constants([xTrain;xValid]);
kept_columns = setdiff(1:size(xTrain,2), constants);
xTrain = xTrain(:,kept_columns);
xValid = xValid(:,kept_columns);
namesX = namesX(kept_columns);
numParams = length(find(kept_columns <= numParams));
transformation.kept_columns = kept_columns;

% 3. Split Xs and names into parameters and features
paramsTrain = xTrain(:,1:numParams);
xTrain = xTrain(:,numParams+1:end);
paramsValid = xValid(:,1:numParams);
xValid = xValid(:,numParams+1:end);
transformation.numParams = numParams;

namesParams = namesX(1:numParams);
namesX = namesX(numParams+1:end);
transformation.namesParams=namesParams;
transformation.namesX=namesX;

% 4a. Normalize combinations w.r.t. the training data (mostly for PCA, 
%     but also for the following ML in the feature selection)
[scale1, bias1] = determine_transformation([xTrain;xValid],2);
xTrain = (xTrain - repmat(bias1, [size(xTrain,1),1])) ./ repmat(scale1, [size(xTrain,1),1]);
xValid = (xValid - repmat(bias1, [size(xValid,1),1])) ./ repmat(scale1, [size(xValid,1),1]);
transformation.scale1=scale1;
transformation.bias1=bias1;


% 4. PCA
if c.numPcaComponents>0
    numActualPCAComponents = min([c.numPcaComponents, size(xTrain, 2)]);
    [pccoeff, pcVec] = pca([xTrain;xValid],numActualPCAComponents);
%    cc=[];
%     for i=1:size(xTrain,2);
%         for j=1:size(xTrain,2)
%             tmp=corrcoef(xTrain(:,i), xTrain(:,j));
%             cc(i,j)=tmp(1,2);
%         end
%     end
     xTrain = xTrain*pcVec;
     xValid = xValid*pcVec;
%     cca=[];
%     for i=1:size(xTrain,2);
%         for j=1:size(xTrain,2)
%             tmp=corrcoef(xTrain(:,i), xTrain(:,j));
%             cca(i,j)=tmp(1,2);
%         end
%     end
    transformation.pcVec = pcVec;
    fprintf('Chose %d features with PCA.\n', size(xTrain,2));
else
    transformation.pcVec = eye(size(xTrain,2));
end

% 5. Call feature selection to select the most informative
%    instance features (no params involved yet)
if size(xTrain,2)>c.linearSize
    [setOfFeatureIndices, bestIndex] = feature_select(xTrain,yTrain,xValid,yValid,namesX, c.linearSize);%sort
    feature_indices = setOfFeatureIndices{bestIndex};
    transformation.linearFeatureIndices = feature_indices;

    xTrain = xTrain(:,feature_indices);
    xValid = xValid(:,feature_indices);
    namesX = namesX(feature_indices);
    transformation.namesX=namesX;
    transformation.linearFeatureIndices = feature_indices;
    fprintf('Picked %d features with linear forward selection.\n', size(xTrain,2));
else
    transformation.linearFeatureIndices = 1:size(xTrain,2);
end

% 6. Combine these important features with the parameters
%  TODO: Build clean interface allowing to specify the desired polynomial order of the
%  parameters and the instance features. Currently, this is a HACK.
[xTrain, namesX] = buildBasisFunctions(paramsTrain, xTrain, namesParams, namesX, c.doQuadratic);
[xValid, namesX] = buildBasisFunctions(paramsValid, xValid, namesParams, namesX, c.doQuadratic);

% 7. Normalize combinations w.r.t. the training data
[scale2, bias2] = determine_transformation([xTrain;xValid],2);
xTrain = (xTrain - repmat(bias2, [size(xTrain,1),1])) ./ repmat(scale2, [size(xTrain,1),1]);
xValid = (xValid - repmat(bias2, [size(xValid,1),1])) ./ repmat(scale2, [size(xValid,1),1]);
transformation.scale2=scale2;
transformation.bias2=bias2;


% 8. Again, call feature selection software by KLB to select the
%    most informative combined features
%    (this 2-way process is necessary since memory otherwise explodes)
if size(xTrain,2)>c.maxModelSize
    % TODO: klb_feature_select: return all subsets of features up to that size.
    [setOfFeatureIndices, bestIndex] = feature_select(xTrain,yTrain,xValid,yValid,namesX, c.maxModelSize);%sort
    transformation.setOfFinalFeatureIndices = setOfFeatureIndices;
    transformation.bestIndexForFinalFeatures = bestIndex;

    feature_indices = setOfFeatureIndices{bestIndex};
    xTrain = xTrain(:,feature_indices);
    xValid = xValid(:,feature_indices);
    namesX = namesX(feature_indices);
    transformation.finalNamesX=namesX;
    fprintf('Picked %d features with final forward selection.\n', size(xTrain,2));
else
    transformation.setOfFinalFeatureIndices = {1:size(xTrain,2)};
    transformation.bestIndexForFinalFeatures = 1;
end