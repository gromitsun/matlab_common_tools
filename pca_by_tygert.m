function [coeff, score, latent] = pca_by_tygert(x, rank, varargin)

n = size(x, 1);

if nargin < 2
    rank = n;
end

% The pca_tygert function is basically a centered SVD, i.e. it computes
% [U,S,V] = svd(x-mean(x,1), 'econ')
[U,S,coeff] = pca_tygert(x, rank, varargin{:});

score = U*S;
latent = diag(S).^2/(n-1);

end