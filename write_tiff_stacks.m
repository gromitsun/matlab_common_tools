function write_tiff_stacks(img, outname, dim, normclip)

if nargin < 4
    normclip = 1;
end

if nargin < 3
    dim = 3;
end

if normclip
    img = imnorm(imclip(img,0.02,0.98,1));
end

for K=1:size(img, dim)
    fprintf('Writing image #%g -> %s\n',K,outname);
    imwrite(squeeze(ndslice(img,K,dim)), outname, 'WriteMode', 'append', 'Compression', 'none');
end

end