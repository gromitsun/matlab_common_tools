function out = readnd(fid, format, shape, slices)
%Read binary files as ND volumetric data
% Inputs:
% fid - opened binary file handler or string containing filename.
% format - string of data type (e.g. 'double', 'single', 'single=>double', etc.)
%          if only one format specified, output will be the same format as
%          input.
% shape - dimensions of the ND object [dim1 dim2 dim3 ... dimN] (fastest -> slowest).
% slices - (optional) First and last indices of the ROI in each dimension.

if nargin < 4
    slices = [ones(numel(shape),1) shape(:)];
end

% Process input and output format
format = strsplit(format, '=>');

% Determine if fid is a file name
if isa(fid, 'char')
	fid = fopen(fid, 'r');
	cls = 1;
else
    cls = 0;
end

% Get range in N dimensions
slices = reshape(slices', 2, [])';

% Compute size of output array
shape_out = (slices(:,2) - slices(:,1) + 1)';

% Prepare array for output
out = zeros(shape_out, format{end});

% Get word length
nbytes = getbytes(format{1});

% Compute reading offsets in each dimension
offset = [slices(:,1)-1 shape(:)-slices(:,2)];
offset = offset .* repmat(cumprod([1 shape(1:end-1)])', [1, 2]) * nbytes;

% Seek along the last dimension
fseek(fid, offset(end,1), 'bof');

% Read data
prod_shape = cumprod(shape_out(2:end));
for i = 1:prod_shape(end)
    fseek(fid, (rem(i-1, prod_shape(1:end-1))==0)*offset(2:end-1,1)+offset(1,1),'cof');
    ind = myind2sub(shape_out(2:end),i);
    s = num2cell(ind);
    out(:,s{:}) = fread(fid, shape_out(1), format{1});
    fseek(fid, (ind(1:end-1)==shape_out(2:end-1))*offset(2:end-1,2)+offset(1,2),'cof');
end

% close the file if needed
if cls
	fclose(fid);
end

end
    