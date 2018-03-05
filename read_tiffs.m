function out = read_tiffs(fname, istart, iend)

indices = istart:iend;

nz = numel(indices);

fprintf('Loading %d (%d of %d)\r', indices(1), 1, nz);
out = imread(sprintf(fname, indices(1)));
out = padarray(out, [0 0 nz-1], 'post');

for i = 2:nz
    fprintf('Loading %d (%d of %d)\r', indices(i), i, nz);
    out(:,:,i) = imread(sprintf(fname, indices(i)));
end
fprintf('\n');
