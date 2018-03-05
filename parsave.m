function parsave(filename, variable, vargin)
%Save variable to .mat file in a parfor loop.
a.(inputname(2))=variable;
save(filename, '-struct', 'a', inputname(2), vargin)
end