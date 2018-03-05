function bw0 = maskbg(im, radius, sigma)

if nargin < 3
    sigma = radius;
end

im0 = im;
im0 = imerode(im0, strel('disk',radius));
if sigma > 0
    im0 = imgaussfilt(im0,sigma);
end
level = graythresh(im0);
bw0 = im2bw(im0,level);
bw0 = bwareafilt(bw0,1);
bw0 = imfill(bw0,'holes');

end