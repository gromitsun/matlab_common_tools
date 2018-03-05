function [ticks, labels] = gen_ticks(npoints, sep, unit_per_pixel)

if nargin < 3
    unit_per_pixel = 1;
end

r = (npoints+1)/2;

labels = (-floor(npoints*unit_per_pixel/sep):floor(npoints*unit_per_pixel/sep))*sep;
ticks = labels/unit_per_pixel+r;

end