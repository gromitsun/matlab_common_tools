function out = readbin(fid, shape, format)
%Read binary files as ND volumetric data
% Inputs:
% fid - opened binary file handler, or string containing a file name.
% shape - dimensions of the 3D object [dim1 dim2 dim3] (fastest -> slowest).
% format - string indicating the format of the data values (e.g. 'float'). Default is 'double'.


% Check inputs
if nargin < 3
	format = 'double';
end

if nargin < 2
	shape = [];
end

% Determine if fid is a file name
if isa(fid, 'char')
	fid = fopen(fid, 'r');
	cls = 1;
else
    cls = 0;
end

% Main part: read data
if isempty(shape)
    out = fread(fid, format);
else
    out = reshape(fread(fid,prod(shape),format),shape);
end

% close the file if needed
if cls
	fclose(fid);
end

end