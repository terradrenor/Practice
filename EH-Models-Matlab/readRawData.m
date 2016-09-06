function [instance_ids, namesY, namesX, Y, capped, Solution, X] = readRawData(filename, numOutputs, selectedOutput, remove_capped)

%=== Take care of the numerical values.
%filename;
data = csvread(filename, 1, 0);
%y = log10(data(:,1));
instance_ids = data(:,1);
Y = data(:,selectedOutput+1);
capped = data(:,numOutputs+2);
Solution = data(:,numOutputs+3);
X = data(:,numOutputs+4:end);

if remove_capped
    good = find(capped==0);
    X = X(good,:);
    capped = capped(good);
    Solution = Solution(good);
    Y = Y(good,:);
    instance_ids = instance_ids(good);
end

%=== Take care of the names.
allnames = textread(filename, '%s', 1, 'whitespace', '\n', 'bufsize', 10000);
allnames = strread(allnames{1},'%s','whitespace',',');
allnames = deblank(allnames);

namesY = allnames(selectedOutput);
cappedHeader = allnames(numOutputs+2);
if ~strcmp(cappedHeader, 'capped')
    error('Error, need column capped!')
end
solutionHeader = allnames(numOutputs+3);
if ~strcmp(solutionHeader, 'Solution')
    error('Error, need column Solution!')
end
namesX = allnames(numOutputs+3:end);