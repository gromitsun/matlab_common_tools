function im = nonlinear_aisodiff_1d(im, k0, w, niter, dt, verbose)

% Get verbose option
if nargin < 6
    verbose = false;
end

for i = 1:niter
    k = k0*exp(-dt*(i-1)*w);
    if verbose
        fprintf('Iteration %d with k = %g\n',i, k);
    end
    im = myanisodiff1D(im, 1, dt, k, 1);
end

