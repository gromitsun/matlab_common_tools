function full_disp(a, fmt, sep)

if nargin < 2
    fmt = '%.20f';
end

if nargin < 3
    sep = '\n';
end

for s = a
    fprintf(strcat(fmt,sep), s);
end
    

