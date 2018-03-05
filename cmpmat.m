function [count, stddev, diff] = cmpmat(f1, f2, varmap1, varmap2)

if nargin < 1 || isempty(f1)
    [f1,path1] = uigetfile(pwd, 'Select the first file to compare');
    f1 = fullfile(path1,f1);
    fprintf('%s\n', f1);
end

if nargin < 2 || isempty(f2)
    [f2,path2] = uigetfile(pwd, 'Select the second file to compare');
    f2 = fullfile(path2,f2);
    fprintf('%s\n', f2);
end

m1 = matfile(f1);
m2 = matfile(f2);

d1 = whos(m1);
d2 = whos(m2);


if nargin < 3
    varmap1 = {d1.name};
    varmap2 = varmap1;
end

if nargin < 4
    varmap2 = varmap1;
end

count = -ones(1, numel(varmap2));
if nargout > 1
    stddev = zeros(1, numel(varmap2));
end
if nargout > 2
    diff = {};
end


for i = 1:numel(varmap2)
    varname1 = cell2mat(varmap1(i));
    varname2 = cell2mat(varmap2(i));
    
    if ~ismember(varname1, {d1.name})
        fprintf('%s not found in %s!\n', varname1, f1);
        continue
    end
    
    if ~ismember(varname2, {d2.name})
        fprintf('%s not found in %s!\n', varname2, f2);
        continue
    end

    fprintf('Comparing variable %s and %s\n', varname1, varname2);

    dd1 = whos(m1, varname1);
    dd2 = whos(m2, varname2);

    if ~isequal(dd1.size, dd2.size);
        s1 = sprintf('%g ', dd1.size);
        s2 = sprintf('%g ', dd2.size);
        fprintf('Dimension mismatch! [%s\b] vs [%s\b]\n',s1,s2);
        continue
    end

    var1 = m1.(varname1);
    var2 = m2.(varname2);

    t = (var1==var2);
    if ~all(t(:))
        count(i) = sum(~t(:));
        fprintf('%g values are not equal!\n', sum(~t(:)));
        if nargout > 1
            diff1 = var2 - var1;
            stddev(i) = std(diff1(:));
            fprintf('Stadard deviation = %g, maximum difference = %g\n', stddev(i), max(abs(diff1(:))));
        end
        if nargout > 2
            diff = [diff diff1];
        end
        continue
    end

    fprintf('Pass!\n');
    count(i) = 0;

end

end
