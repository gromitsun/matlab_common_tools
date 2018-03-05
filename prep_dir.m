function prep_dir(path)

[pathstr,~,~] = fileparts(path);

if exist(pathstr, 'dir') ~= 7
    mkdir(pathstr)
end

end

