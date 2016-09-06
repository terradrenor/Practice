function [yPred, yPredVar] = netlab_blr_fwd(net, xTrain, yTrain, xTest)

[yPred, yPredVar] = glmevfwd(net, xTrain, yTrain, xTest);
% % % % % % % The NETLAB implementation of the variance computation is BROKEN ! (weird
% % % % % % % formula)
% % % % % % % Apply equation (2.11) from GP book to get the real thing!
% % % % % % 
% % % % % % [N,D] = size(xTrain);
% % % % % % [M,D] = size(xTest)
% % % % % % 
% % % % % % %xTrain is NxD
% % % % % % for i=1:M
% % % % % % %    phi_star = xTest(i,:);
% % % % % %     Phi = [xTrain'; ones(1,N)];
% % % % % %     phi_star = [xTest(i,:), 1]';
% % % % % % %    phi_star = [xTest, ones(1,size(xTest,1))];
% % % % % %     Sigma_p = 1/net.alpha*eye(D+1);
% % % % % %     A = net.beta*Phi*Phi' + inv(Sigma_p);
% % % % % %     yPredVarReal = phi_star'*inv(A)*phi_star + 1/net.beta
% % % % % % %    yPredVar = diag(yPredVarReal);
% % % % % % end
% % % % % % yPredVar
% % % % % % err
yPred_std = sqrt(yPredVar);
alpha = net.alpha;
beta = net.beta;
