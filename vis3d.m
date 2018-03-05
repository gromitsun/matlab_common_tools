function h = vis3d(filename, shape, precision)


fid = fopen(filename, 'r');
data = reshape(fread(fid,prod(shape),precision),shape);

FV = isosurface(data,0);
% FV = smoothpatch(FV,1,10);

h = patch(FV, 'EdgeColor', 'none', 'FaceColor', [255 215 0]/255);

end