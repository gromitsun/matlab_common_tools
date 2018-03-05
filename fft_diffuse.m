function out = fft_diffuse(a, nt, dt, D)


if nargin < 4
    D = -1;
end

sz = size(a);

% kx = 2*pi/sz(1) * fftshift(-round(sz(1)/2):round(sz(1)/2)-1);
% ky = 2*pi/sz(2) * fftshift(-round(sz(2)/2):round(sz(2)/2)-1);
% kz = 2*pi/sz(3) * fftshift(-round(sz(3)/2):round(sz(3)/2)-1);
% 
% [KX2, KY2, KZ2] = meshgrid(ky.^2, kx.^2, kz.^2);
% 
% K2 = KX2 + KY2 + KZ2;

% kvec = cell(1, ndims(a));
% k2vec = cell(1, ndims(a));


k2mat = zeros(sz);

for i = 1:ndims(a)
    kvec = 2*pi/sz(i) * fftshift(-round(sz(i)/2):round(sz(i)/2)-1);
    k2vec = kvec.^2;
    sz1 = ones(1, ndims(a));
    sz1(i) = sz(i);
    szn = sz;
    szn(i) = 1;
    k2mat = k2mat + repmat(reshape(full(k2vec), sz1), szn);
end

out = fftn(a);

for i = 1:nt
    out = out + dt * D * k2mat .* out;
end

out = ifftn(out);