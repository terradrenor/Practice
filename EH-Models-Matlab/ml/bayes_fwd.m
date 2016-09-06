function [Y_mean, Y_var] = bayes_fwd(mu_w, Sigma_w, beta, X)
% BAYES_FWD
% Returns the predictive mean and variance for a linear regression model
% with weights given by a N(mu_w, Sigma_w), evaluated at the data point x.
%
% INPUT: 
% mu_w: Mx1 mean weight vector
% Sigma_w: MxM weight covariance
% beta: scalar observation precision (1/sigma_obs^2)
% X: NxM matrix, representing N data points of dimension M
%
% OUTPUT:
% Y_mean: Nx1 predictive scalar means for the N points
% Y_var: Nx1 predictive scalar variances for the N points

[N,D] = size(X);
X = [ones(N,1),X];

Y_mean = X * mu_w;
%=== Could get the whole covariance for the outputs if we wanted. 
%=== But this is an NxN matrix, big for lots of data points
%Y_var = diag(1/beta + X * Sigma_w * X');
for i=1:size(X,1)
    Y_var(i,1) = 1/beta + X(i,:) * Sigma_w * X(i,:)';
end