function write_tiff_stacks_fp(img, outname, bits)

if nargin < 3
    bits = 64;
end

fprintf('Writing image %s ...\n', outname);

t = Tiff(outname, 'w');
t.setTag('Photometric',Tiff.Photometric.MinIsBlack);
t.setTag('Compression',Tiff.Compression.None);
t.setTag('SampleFormat',Tiff.SampleFormat.IEEEFP);
t.setTag('BitsPerSample',bits)
t.setTag('SamplesPerPixel',size(img,3));
t.setTag('ImageLength',size(img,1));
t.setTag('ImageWidth',size(img,2));
t.setTag('PlanarConfiguration',Tiff.PlanarConfiguration.Chunky);

t.write(img);

t.close();

end