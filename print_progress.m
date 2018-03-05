function revstr = print_progress(msgstr, num, revstr)

if nargin < 3
    revstr = '';
end

for j=0:100

    fprintf(revstr);
    msg=fprintf(msgstr, num);                                
    revstr = repmat(sprintf('\b'), 1, msg);
    
end
