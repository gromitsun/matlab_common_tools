function out = grad2(im)
% Calculates gradient square of 2D array im.

kx = genfftk(size(im,1));
ky = genfftk(size(im,2));

[ky2,kx2] = meshgrid(ky.^2,kx.^2);

out = ifft2(-(kx2+ky2).*fft2(im));

end
