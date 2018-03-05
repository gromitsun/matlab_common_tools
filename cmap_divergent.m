function cmap = cmap_divergent(nlevels, style)
%cmap_divergent creates a divergnet colormap.

%% Parse input arguments
if nargin < 1
    nlevels = 64;
end

if nargin < 2
    style = '';
end


%% Asymmetric levels
if numel(nlevels) > 1
    % if asymmetric number of levels in blue and red is desired, generate
    % the colormap by two recursive calls
    ncb = nlevels(1); % # of colors in blue shade
    ncr = nlevels(2); % # of colors in red shade
    cmap1 = cmap_interp(redbluecmap(11), ncb*2+1);
    cmap2 = cmap_interp(redbluecmap(11), ncr*2+1);
    cmap = [cmap1(1:ncb,:); [1 1 1]; cmap2(ncr+2:end,:)];
    return;
end

%% Standard (symmetric) case
switch style
    case '' % red + blue
        cmap0 = redbluecmap;
        
    case 'rg' % red + green
        cmap0 = redgreencmap;
end

n0 = size(cmap0, 1);
cmap = interp1(1:n0, cmap0, linspace(1,n0,nlevels));
