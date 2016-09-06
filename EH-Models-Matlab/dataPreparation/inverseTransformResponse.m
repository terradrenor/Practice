function Y = inverseTransformResponse(transformation, Y)
switch transformation
    case 'log10'
        Y = 10.^Y;
    case 'logistic'
        Y = 3600 ./ (1.0 + exp(-Y));
    case 'identity'
        Y = Y;
    otherwise
        error('Error, transformation has to be log10, logistic, or identity')
end
