function model = learnModel(X, Y, type)
%=== Learn a model for the data and save its parameters. Also save the 
%=== IDs of the training instances for future reference.

model.type=type;

switch type
    case 'BLR'
        % for Bayesian linear regression
        [N,M] = size(X);
        beta = 1; % observarion precision 1/sigma_obs^2.
        mean_0 = 0*ones(M+1,1); % Mx1 matrix, zero mean.
        Sigma_0 = 1e2 * eye(M+1,M+1); % MxM matrix, wide prior.

        [mu_w, Sigma_w] = bayesian_update(mean_0, Sigma_0, beta, X, Y);
        model.mu = mu_w;
        model.Sigma = Sigma_w;
        model.beta = beta;
    case 'Netlab-BLR'
        model.net = netlab_blr_train(X, Y);
        model.xTrain = X;
        model.yTrain = Y;
    case 'GP-SEard'
        model.covfunc = {'covSum', {'covSEard','covNoise'}};
        model = gp_train(model, X, Y);
    case 'GP-SEiso'
        model.covfunc = {'covSum', {'covSEiso','covNoise'}};
        model = gp_train(model, X, Y);
    case 'GP-M3iso'
        model.covfunc = {'covSum', {'covMatern3iso','covNoise'}};
        model = gp_train(model, X, Y);
    case 'GP-M5iso'
        model.covfunc = {'covSum', {'covMatern5iso','covNoise'}};
        model = gp_train(model, X, Y);        
    otherwise
        error ('No such model type defined yet!');
end


%=== Function for training GP - called for all covariance functions.
function model = gp_train(model, xTrain, yTrain)

numTrain = 1000;
if 1 %=== Stratify training data according to response.
    numclusters = 5;
    diffMaxMin = max(yTrain) - min(yTrain);
    c_train_idxs = [];
    lower_bound = min(yTrain);
    inc = diffMaxMin/numclusters;

    numPointsPerCluster = floor(numTrain/numclusters + 0.5);
    for i=1:numclusters
        % same random seed for every number of data points so we have supersets of training data.
        rand('state',i*10); 

        idxs_in_cluster = intersect(find(yTrain>lower_bound),find(yTrain<lower_bound+inc));
        randnums = randperm(length(idxs_in_cluster));
        % If not enough training points in this cluster, only use those available.
        idxs = idxs_in_cluster(randnums(1:min(numPointsPerCluster,length(idxs_in_cluster))));
        c_train_idxs = [c_train_idxs, idxs'];
        lower_bound = lower_bound+inc;
    end
%    effective_numsTrain = [effective_numsTrain, length(c_train_idxs)];
    xTrain = xTrain(c_train_idxs,:);
    yTrain = yTrain(c_train_idxs,:);
else
    rand('state',42);
    randnums = randperm(size(xTrain,1));
    randidxs = randnums(1:min(numTrain, length(randnums)));
    xTrain = xTrain(randidxs,:);
    yTrain = yTrain(randidxs,:);
end
[N,D] = size(xTrain);
num_hyperparams = eval(feval(model.covfunc{:}));
loghyper = 0.1*ones(num_hyperparams,1);
[loghyper, all_margLs, i, all_loghyperparams] = minimize(loghyper, 'gpr', -200, model.covfunc, xTrain, yTrain);
model.loghyper = loghyper;
model.xTrain = xTrain;
model.yTrain = yTrain;