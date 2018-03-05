function h = imoverlay(I,label,format)
% Display overlayed image of the original image (I) and segmented data
% (label)

if nargin < 3
    format = 'segment';
end

if ~strcmp(format, 'contour')
    Lrgb = label2rgb(label, 'jet', 'w', 'shuffle');

    h = figure();
    imshow(I)
    hold on
    himage = imshow(Lrgb);
    himage.AlphaData = 0.3;
    hold off

else
    imshow(I)
    hold on
    label_list = sort(unique(label));
    level_list = (label_list(1:end-1)+label_list(2:end))/2;
    rgb_list = label2rgb(0:(numel(level_list)-1), 'jet', 'r', 'shuffle');
    for i = 1:numel(level_list)
        contour(label, 'LevelList', level_list(i), 'LineColor', rgb_list(1,i,:), 'LineWidth', 2);
    end
    hold off
end

end