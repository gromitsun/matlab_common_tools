function savebov(filename, a)

s = whos('a');
argname = inputname(2);
precision = s.class;
format = precision_to_format(precision);
if format == -1
    error('Unsupported data format ''%s''', precision);
end


[pathstr,name,ext] = fileparts(filename);
if isempty(ext)
    ext = '.bov';
end
path2bov = fullfile(pathstr, strcat(name, ext));
path2bin = fullfile(pathstr, strcat(name, '.bin'));
basename = strcat(name, '.bin');

f1 = fopen(path2bov, 'w');
f2 = fopen(path2bin, 'wb');


fprintf(f1, '# TIME: 0\n');
fprintf(f1, 'DATA_FILE: %s\n', basename);
fprintf(f1, '# The data size corresponds to NX,NY,NZ in the above example code.\n');
fprintf(f1, 'DATA_SIZE: %d %d %d\n', size(a,1), size(a,2), size(a,3));
fprintf(f1, '# Allowable values for DATA_FORMAT are: BYTE,SHORT,INT,FLOAT,DOUBLE\n');
fprintf(f1, 'DATA_FORMAT: %s\n', format);
fprintf(f1, 'VARIABLE: %s\n', argname);
fprintf(f1, '# Endian representation of the computer that created the data.\n');
fprintf(f1, '# Intel is LITTLE, many other processors are BIG.\n');
fprintf(f1, 'DATA_ENDIAN: LITTLE\n');
fprintf(f1, '# Centering refers to how the data is distributed in a cell. If you\n');
fprintf(f1, '# give ''zonal'' then it''s 1 data value per zone. Otherwise the data\n');
fprintf(f1, '# will be centered at the nodes.\n');
fprintf(f1, 'CENTERING: zonal\n');
fprintf(f1, '# BRICK_ORIGIN lets you specify a new coordinate system origin for\n');
fprintf(f1, '# the mesh that will be created to suit your data.\n');
fprintf(f1, 'BRICK_ORIGIN: 0. 0. 0.\n');
fprintf(f1, '# BRICK_SIZE lets you specify the size of the brick.\n');
fprintf(f1, 'BRICK_SIZE: %g %g %g\n', size(a,1), size(a,2), size(a,3));
fclose(f1);

fwrite(f2, a, precision);
fclose(f2);

end

function format = precision_to_format(precision)

if strcmp(precision, 'uint8') || strcmp(precision, 'int8')
    format = 'BYTE';
elseif strcmp(precision, 'uint16') || strcmp(precision, 'int16')
    format = 'SHORT';
elseif strcmp(precision, 'uint32') || strcmp(precision, 'int32') || strcmp(precision, 'int')
    format = 'INT';
elseif strcmp(precision, 'single')
    format = 'FLOAT';
elseif strcmp(precision, 'double')
    format = 'DOUBLE';
else
    format = -1;
end
    

end
