function h = slice_plot_3d(vol, varargin)
% plot slices by using slice_plane_3d and matlab native interp3 function
% axes order is 'xyz' (non-MATLAB order)

%% Input parser
p = inputParser;
% Slicing axes
p.addParameter('SliceAxes', [], @isnumeric);
p.addParameter('SliceOrigin', (size(vol)+1)/2, @isnumeric);
% Length unit
p.addParameter('LengthUnit', '', @isstr);
p.addParameter('PixelSize', 1, @isnumeric);
% Color map
p.addParameter('LogNorm', false, @isnumeric);
p.addParameter('CMap', 'default');
% Visibility
p.addParameter('Visible', 'on', @isstr);
% Axis properties
p.addParameter('AxProps', {});

parse(p, varargin{:});

slice_axes = p.Results.SliceAxes;
slice_origin = p.Results.SliceOrigin;
length_unit = p.Results.LengthUnit;
pixel_size = p.Results.PixelSize;
lognorm = p.Results.LogNorm;
cmap = p.Results.CMap;
visible = p.Results.Visible;
ax_props = p.Results.AxProps;



% principal axes
n1 = slice_axes(:,1);
n2 = slice_axes(:,2);
n3 = slice_axes(:,3);

%% initialize handles
h = [];

%% get dimensions
sz = size(vol);

%% plots
%% perpendicular to secondary arms
figname = 'n1n3';
h = [h, figure('Name', figname, 'NumberTitle', 'off', 'Visible', visible)];
[xd, yd, zd] = slice_plane_3d(sz, n1, n2, n3, 'dim', 2, 'order', 'xyz', 'point', slice_origin);
im = interp3(vol, yd, xd, zd, 'nearest');
% [xd, yd, zd] = slice_plane_3d(sz([ 2 1 3]), n1([2 1 3]), n3([2 1 3]), n2([2 1 3]));
% im = interp3(GG, xd, yd, zd, 'nearest');
if lognorm
	log_image(im, 'AlphaData', ~isnan(im));
else
	imagesc(im, 'AlphaData', ~isnan(im));
	colorbar
end
xlabel(sprintf('n_1 (%s)',length_unit),'FontSize',24,'FontWeight','bold');
ylabel(sprintf('n_3 (%s)',length_unit),'FontSize',24,'FontWeight','bold');
axis image
ax = gca();
[ax.XTick, ax.XTickLabel] = gen_ticks(size(im,2), 100, pixel_size);
[ax.YTick, ax.YTickLabel] = gen_ticks(size(im,1), 100, pixel_size);
ax.FontSize = 18;


%% parallel to secondary arms (approx. along x)
figname = 'n1n2';
h = [h, figure('Name', figname, 'NumberTitle', 'off', 'Visible', visible)];
[xd, yd, zd] = slice_plane_3d(sz, n1, n2, n3, 'dim', 3, 'order', 'xyz', 'point', slice_origin);
im = interp3(vol, yd, xd, zd, 'nearest')';
% [xd, yd, zd] = slice_plane_3d(sz([ 2 1 3]), n2([2 1 3]), n1([2 1 3]), n3([2 1 3]));
% im = interp3(GG, xd, yd, zd, 'nearest')';
if lognorm
	log_image(im, 'AlphaData', ~isnan(im));
else
	imagesc(im, 'AlphaData', ~isnan(im));
	colorbar
end
xlabel(sprintf('n_1 (%s)',length_unit),'FontSize',24,'FontWeight','bold');
ylabel(sprintf('n_2 (%s)',length_unit),'FontSize',24,'FontWeight','bold');
axis image
ax = gca();
[ax.XTick, ax.XTickLabel] = gen_ticks(size(im,2), 100, pixel_size);
[ax.YTick, ax.YTickLabel] = gen_ticks(size(im,1), 100, pixel_size);
ax.FontSize = 18;

%% parallel to secondary arms (approx. perpendicular to x)
figname = 'n2n3';
h = [h, figure('Name', figname, 'NumberTitle', 'off', 'Visible', visible)];
[xd, yd, zd] = slice_plane_3d(sz, n1, n2, n3, 'dim', 1, 'order', 'xyz', 'point', slice_origin);
im = interp3(vol, yd, xd, zd, 'nearest');
% [xd, yd, zd] = slice_plane_3d(sz([ 2 1 3]), n3([2 1 3]), n2([2 1 3]), n1([2 1 3]));
% im = interp3(GG, xd, yd, zd, 'nearest');
if lognorm
	log_image(im, 'AlphaData', ~isnan(im));
else
	imagesc(im, 'AlphaData', ~isnan(im));
	colorbar
end
xlabel(sprintf('n_3 (%s)',length_unit),'FontSize',24,'FontWeight','bold');
ylabel(sprintf('n_2 (%s)',length_unit),'FontSize',24,'FontWeight','bold');
axis image
ax = gca();
[ax.XTick, ax.XTickLabel] = gen_ticks(size(im,2), 100, pixel_size);
[ax.YTick, ax.YTickLabel] = gen_ticks(size(im,1), 100, pixel_size);
ax.FontSize = 18;


for hh=h
    ax = hh.CurrentAxes;
%     ax.FontSize = 16;

    % zero lines
%     hold(ax, 'on');
%     plot(ax, [-1 1], [0 0], 'w--', 'LineWidth', 2);
%     plot(ax, [0 0], [-1 1], 'w--', 'LineWidth', 2);
%     hold(ax, 'off');


    % set color map
    switch cmap
        case 'divergent'
            % divergent colormap <-- use this for Pearson correlation maps
            colormap(ax, cmap_divergent);
            lim = max(abs(min(vol(:))), abs(max(vol(:))));
            ax.CLim = [-lim, lim];
        case 'rainbow'
            % rainbow colormap with black background <-- use this for regular 2-pt
            % correlation maps
            colormap(ax, cmap_spectrum(64, 'no_violet'));
        otherwise
            colormap(ax, cmap);
    end
    
            

    % set log-scale colorbar labels
    if lognorm
        hc = colorbar(ax);
        hc.Ticks = log10([(1:9)/100, (1:10)/10, (2:10)]);
        hc.TickLabels = [(1:9)/100, (1:10)/10, (2:10)];
    end
    ax.YDir = 'normal';
    
    % set customized axis properties
    if ~isempty(ax_props)
        set(ax, ax_props{:});
    end
    
end
h(1).CurrentAxes.YDir = 'reverse'; % so that n1n3 plot is looking from top-down