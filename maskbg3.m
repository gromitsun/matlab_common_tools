function bw0 = maskbg3(im, radius, sigma)

if nargin < 3
    sigma = radius;
end

im0 = im;
im0 = imerode(im0, strel('disk',radius));
if sigma > 0
    im0 = imgaussfilt3(im0,sigma);
end
level = graythresh(im0);
bw0 = im0 > level;
% bw0 = nth_conncomp(bw0,1);
% bw0 = imfill(bw0,'holes');

end