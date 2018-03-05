function [hl, ht] = scalebar(varargin)
%Creates scalebar on 2D plot
    [ax, args, nargs] = axescheck(varargin{:});
    if isempty(ax)
        ax = gca();
    end
    if nargs == 6
        [x0, y0, theta, len, label, label_theta] = args{:};
    else
        if nargs == 5
            [x0, y0, theta, len, label] = args{:};
            label_theta = [];
        else
            [x0, y0, theta, len] = args{:};
            label = [];
            label_theta = [];
        end
    end
        
    theta_rad = deg2rad(theta);
    lenx = cos(theta_rad)*len;
    leny = sin(theta_rad)*len;
    x = [x0-lenx/2, x0+lenx/2];
    y = [y0-leny/2, y0+leny/2];   
    hl = line(x, y, 'Parent', ax);
    hl.LineWidth = 2;
    
    % text on scale bar
    if ~isempty(label)
        ht = text(x0, y0, label, 'Parent', ax);
        ht.FontSize = 18;
        ht.Color = hl.Color;
        ht.VerticalAlignment = 'bottom';
        ht.HorizontalAlignment = 'center';
        if ~isempty(label_theta) % get rotation of text from input
            ht.Rotation = label_theta;
        else % auto determine rotation of text
            if rem(theta, 90)==0
                ht.Rotation = theta;
            else
                ax.PlotBoxAspectRatioMode = 'manual';
                ar = ax.PlotBoxAspectRatio(1:2);
                ht.Rotation = rad2deg(atan(tan(theta_rad)*ar(2)/ar(1)));
            end
        end
    end  
end