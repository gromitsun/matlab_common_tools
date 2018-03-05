function plot_outline_3d(vol, varargin)

p = inputParser;
p.addParameter('SliceAxes', [], @isnumeric);

parse(p, varargin{:});

slice_axes = p.Results.SliceAxes;


%% Get size of V
sz = size(vol);

%% bulk surface plot
[xx, yy, zz] = meshgrid((1:sz(2))-(sz(2)+1)/2, (1:sz(1))-(sz(1)+1)/2, (1:sz(3))-(sz(3)+1)/2);

hold on;
surf(xx(:,:,1), yy(:,:,1), zz(:,:,1), vol(:,:,1), 'EdgeColor', 'none');
surf(xx(:,:,end), yy(:,:,end), zz(:,:,end), vol(:,:,end), 'EdgeColor', 'none');
surf(squeeze(xx(:,1,:)), squeeze(yy(:,1,:)), squeeze(zz(:,1,:)), squeeze(vol(:,1,:)), 'EdgeColor', 'none');
surf(squeeze(xx(:,end,:)), squeeze(yy(:,end,:)), squeeze(zz(:,end,:)), squeeze(vol(:,end,:)), 'EdgeColor', 'none');
surf(squeeze(xx(1,:,:)), squeeze(yy(1,:,:)), squeeze(zz(1,:,:)), squeeze(vol(1,:,:)), 'EdgeColor', 'none');
surf(squeeze(xx(end,:,:)), squeeze(yy(end,:,:)), squeeze(zz(end,:,:)), squeeze(vol(end,:,:)), 'EdgeColor', 'none');
hold off;
colormap(cmap_divergent);
axis off;
axis vis3d;
axis(max(sz)*[-1, 1, -1, 1, -1, 1]);


%% slice planes
if ~isempty(slice_axes)
    % principal axes
    n1 = slice_axes(:,1);
    n2 = slice_axes(:,2);
    n3 = slice_axes(:,3);

    hold on;
    faces = [1 2 3; 2 3 4];
    verts = 0.75 * max(sz) * [ n1+n2; n1-n2; -n1+n2; -n1-n2];
    patch('Faces', faces, 'Vertices', verts(:,[2 1 3]), 'FaceColor', 'red', 'EdgeColor', 'none', 'FaceAlpha', 0.3);
    verts = 0.75 * max(sz) * [ n3+n2; n3-n2; -n3+n2; -n3-n2];
    patch('Faces', faces, 'Vertices', verts(:,[2 1 3]), 'FaceColor', 'red', 'EdgeColor', 'none', 'FaceAlpha', 0.3);
    verts = 0.75 * max(sz) * [ n1+n3; n1-n3; -n1+n3; -n1-n3];
    patch('Faces', faces, 'Vertices', verts(:,[2 1 3]), 'FaceColor', 'red', 'EdgeColor', 'none', 'FaceAlpha', 0.3);
    hold off;
end

end