function kx = genfftk(N,dx)

if nargin < 2
    dx=1;
end

kx = (2*pi/(N*dx))*[0:N/2-1,0,-N/2+1:-1];

end