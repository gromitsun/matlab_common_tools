function cmap = cmap_spectrum(nlevels, style)


if nargin < 1
    nlevels = 64;
end

if nargin < 2
    style = '';
end

n = round((nlevels-1)/9);
inc = 0.5/n;

switch style
    case '' % with violet
        cmap0 = [0 0 0; 0.5 0 0.5; 0 0 1; 0 0.5 1; 0 1 1; 0.5 1 0.5; 1 1 0; 1 0.5 0; 1 0 0; 0.5 0 0];
        cmap = interp1(0:0.5:4.5, cmap0, 0:inc:4.5);
    case 'no_violet' % no violet
        cmap0 = [0 0 0; 0 0 1; 0 1 1; 1 1 0; 1 0 0; 0.5 0 0];
        cmap = interp1([0:4, 4.5], cmap0, 0:inc:4.5);
    case 'rainbow' % no dark colors, only bright colors (with violet)
        cmap0 = [1 0 1; 0 0 1; 0 1 1; 1 1 0; 1 0 0];
        cmap = interp1(0:4, cmap0, 0:inc:4);
    case 'jet' % no dark colors, only bright colors (no violet)
        cmap0 = [0 0 1; 0 1 1; 1 1 0; 1 0 0];
        cmap = interp1(0:3, cmap0, 0:inc:3);
end

