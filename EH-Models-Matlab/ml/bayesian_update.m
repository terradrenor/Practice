function [mu_w, Sigma_w] = bayesian_update(mu_w, Sigma_w, beta, X, Y)
% BAYESIAN_UPDATE
% Updates the Normal distribution of the weights of a linear model
% with new data points.
%
% INPUT: 
% mu_w: Mx1 mean weight vector
% Sigma_w: MxM weight covariance
% beta: scalar observation precision (1/sigma_obs^2)
% X: NxM matrix, representing N data points of dimension M
% Y: Nx1 vector holding the response variable.
%
% OUTPUT:
% mu_w: Updated Mx1 mean weight vector
% Sigma_w: Updated MxM weight covariance
%
% This implements the Bayesian update from Chris Bishop's new book in
% chapter 8.4
[N,D] = size(X);
X = [ones(N,1),X];

Sigma_old_inv = pinv(Sigma_w);
Sigma_w = pinv(Sigma_old_inv + (beta * X' * X));
mu_w = (Sigma_w*Sigma_old_inv) * mu_w + (beta * Sigma_w * X' * Y);