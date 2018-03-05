function im = nonlinear_aisodiff_2d(im, k0, w, niter, dt, verbose)

% Get verbose option
if nargin < 6
    verbose = false;
end

for i = 1:niter
    k = k0*exp(-dt*(i-1)*w);
    if verbose
        fprintf('Iteration %d with k = %g\n',i, k);
    end
    im = myanisodiff2D(im, 1, dt, k, 1);
end

