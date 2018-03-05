function [coeff, score, latent] = pca_by_svd(x, varargin)

% x is a (n by m) matrix, each row represents one observation, each column
% represents one variable (same convention as in MATLAB, reverse of Jon
% Shlens'.
n = size(x, 1);
% Center x about the means of each variable
% This is 'Y' in Jon Shlens
x = (x - mean(x, 1))/sqrt(n-1);

% Compute SVD of Y
% The loadings or coeff is the V in SVD
[U, S, coeff] = svd(x, varargin{:});
% The latent or the variance matrix S_X is s^2
latent = S^2;
% The component scores is U*S/sqrt(n-1) = x*V
score = U*S*sqrt(n-1);

end