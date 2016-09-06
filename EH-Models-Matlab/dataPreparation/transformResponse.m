function Y = transformResponse(transformation, Y)
switch transformation
    case 'log10'
        Y=log10(Y);
    case 'logistic'
        Y = Y./3600; % was capTime
        Y = log(Y) - log(1-Y);
    case 'identity'
        Y=Y;
    otherwise
        error('Error, transformation has to be log10, logistic, or identity')
end
