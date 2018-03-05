function [im, high_value] = imclip(im, low_percent, high_percent, verbose)

if nargin < 4
    verbose = 0;
end

n = numel(im);
% Calculate indices of low and high limits
low_index = round(low_percent * n);
high_index = round(high_percent * n);
% Sort intensity values
im_sort = sort(im(:));
% Calucate low and high limits
low_value = im_sort(low_index);
high_value = im_sort(high_index);

% Clip image
if nargout == 1
    if low_index > 1
        loc = im < low_value;
        im(loc) = low_value;
        if verbose
            fprintf('Clipped %g pixels with low = %g\n', sum(loc(:)), low_value)
        end
    end

    if high_index < n
        loc = im > high_value;
        im(loc) = high_value;
        if verbose
            fprintf('Clipped %g pixels with high = %g\n', sum(loc(:)), high_value)
        end
    end
else
    im = low_value;
end

end