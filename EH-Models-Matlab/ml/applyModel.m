function [yPred, yPredStd] = applyModel(model, X)

yPredVar = zeros(size(X,1),1);
switch model.type
    case 'BLR'
        % for Bayesian linear regression
        [yPred, yPredVar] = bayes_fwd(model.mu, model.Sigma, model.beta, X);
    case 'Netlab-BLR'
        [yPred, yPredVar] = netlab_blr_fwd(model.net, model.xTrain, model.yTrain, X)
    case 'GP-SEard'
        [yPred, yPredVar] = gpr(model.loghyper, model.covfunc, model.xTrain, model.yTrain, X);
    case 'GP-SEiso'
        [yPred, yPredVar] = gpr(model.loghyper, model.covfunc, model.xTrain, model.yTrain, X);
    case 'GP-M3iso'
        [yPred, yPredVar] = gpr(model.loghyper, model.covfunc, model.xTrain, model.yTrain, X);
    case 'GP-M5iso'
        [yPred, yPredVar] = gpr(model.loghyper, model.covfunc, model.xTrain, model.yTrain, X);
    otherwise
        error ('No such model type defined yet!');
end
yPredStd = sqrt(yPredVar);