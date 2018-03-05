function out = read3d(fid, nbytes, shape, slices)
%Read binary files as 3D volumetric data
% Inputs:
% fid - opened binary file handler or string containing filename.
% nbytes - word length in bytes.
% shape - dimensions of the 3D object [dim1 dim2 dim3] (fastest -> slowest).
% slices - (optional) First and last indices of the ROI in each dimension.

nx = shape(1);
ny = shape(2);

if nargin < 4
    slices = [1, shape(1), 1, shape(2), 1, shape(3)];
end

% Determine if fid is a file name
if isa(fid, 'char')
	fid = fopen(fid, 'r');
	cls = 1;
else
    cls = 0;
end

% Get range in 3 dimensions
x0 = slices(1);
x1 = slices(2);
y0 = slices(3);
y1 = slices(4);
z0 = slices(5);
z1 = slices(6);

% Compute size of output array
nx_out = x1 - x0 + 1;
ny_out = y1 - y0 + 1;
nz_out = z1 - z0 + 1;

% Prepare array for output
out = zeros(nx_out, ny_out, nz_out, 'single');

% Compute reading offsets in each dimension
offset_x = x0 - 1;
offset_y = (y0 - 1) * nx;
offset_z = (z0 - 1) * nx * ny;

% Seek to the first desired element
fseek(fid, offset_z * nbytes, 'bof');

% Read data
for z = 1:nz_out
    fseek(fid, offset_y * nbytes, 'cof');
    for y = 1:ny_out
        fseek(fid, offset_x * nbytes, 'cof');
        out(:,y,z) = fread(fid, nx_out, 'float');
        fseek(fid, (nx - offset_x - nx_out) * nbytes, 'cof');
    end
    fseek(fid, (nx * ny - offset_y - ny_out * nx) * nbytes, 'cof');
end

% close the file if needed
if cls
	fclose(fid);
end

end
    