function im = imnorm(im, im_min, im_max)

if nargin < 3
    im = im - min(im(:));
    im = im / max(im(:));
else
    im = (im - im_min) ./ (im_max - im_min);
end

end