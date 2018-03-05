function [hl, ht] = scalebar3(x0, y0, z0, len, label)
%Creates scalebar on 3D plot
    x = [x0, x0-len, nan, x0, x0  , nan, x0, x0  ];
    y = [y0, y0  , nan, y0, y0-len, nan, y0, y0  ];
    z = [z0, z0  , nan, z0, z0  , nan, z0, z0+len];    
    hl = line(x,y,z);
    hl.LineWidth = 2;
    if nargin == 5
        ht = text(x0, y0, z0, label);
    end
    ht.FontSize = 18;
    ht.Color = hl.Color;
    ht.VerticalAlignment = 'bottom';
  
end