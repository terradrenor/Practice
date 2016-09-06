function net = netlab_blr_train(xTrain, yTrain)

% Set up network parameters.
nin = size(xTrain,2);		% Number of inputs.
nhidden = 0		% Number of hidden units.
nout = 1;		% Number of outputs.
alpha_init = 0.01;		% Initial prior hyperparameter. 
beta_init  = 50.0;	% Initial noise hyperparameter.

% Create and initialize network weight vector.
net = glm(nin, nout, 'linear', alpha_init, beta_init);

% Set up vector of options for the optimiser.
nouter = 100;		% Number of outer loops.
ninner = 1;			% Number of inner loops.
options = zeros(1,18);		% Default options vector.
options(1) = 1;			% This provides display of error values.
options(2) = 1.0e-7;		% Absolute precision for weights.
options(3) = 1.0e-7;		% Precision for objective function.
options(14) = 100;		% Number of training cycles in inner loop. 

gamma=0;
% Train using scaled conjugate gradients, re-estimating alpha and beta.
for k = 1:nouter
    net = glmtrain(net, options, xTrain, yTrain);
%        net = netopt(net, options, xTrain, yTrain, 'scg');
    alpha = net.alpha;
    beta=net.beta;
    [net, gamma] = evidence(net, xTrain, yTrain, ninner);
    fprintf(1, '\nRe-estimation cycle %d:\n', k);
    fprintf(1, '  alpha =  %8.5f\n', net.alpha);
    fprintf(1, '  beta  =  %8.5f\n', net.beta);
    fprintf(1, '  gamma =  %8.5f\n\n', gamma);
    if abs(net.alpha-alpha) < 1e-5 && abs(net.beta-beta) < 1e-5
        break
    end
end