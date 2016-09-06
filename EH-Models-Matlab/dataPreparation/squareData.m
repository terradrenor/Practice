function [sqX, sqNames] = squareData(X,names)

%code is similar to the one used in x2fx
[n m] = size(X);
first=repmat(1:m,m,1);
second=first';
t=first<=second;

sqX = zeros(n, m+m+m*(m-1)/2);
sqX = zeros(size(sqX,1), m+m+m*(m-1)/2);

sqX(:,1:m) = X;
sqX(:,m+1:end) = X(:,first(t)) .* X(:,second(t));

sqNames = {};
if ~isempty(t)
    sqNames = strcat(names(first(t)),'.x.',names(second(t)));
end
sqNames = [names; sqNames];