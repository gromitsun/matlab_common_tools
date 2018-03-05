function a = trim_outlier(a, low, high, verbose)

if nargin < 4
    verbose = 0;
end

out_high = (a>high);
out_low = (a<low);

if verbose
    fprintf('Low outliers = %g, high outliers = %g\n', sum(out_low(:)), sum(out_high(:)))
end
    
a(out_high | out_low) = NaN;

amax = max(a(:));
amin = min(a(:));
a(out_high) = amax;
a(out_low) = amin;

if verbose
    fprintf('After trim: min = %g, max = %g\n', amin, amax)
end

end