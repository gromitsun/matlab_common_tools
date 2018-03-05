function m = rot_about_axis(vec, ang, ang_unit)

if nargin < 3
    ang_unit = 'deg';
end

if strcmp(ang_unit, 'deg')
    ang = deg2rad(ang);
end

vec = vec / norm(vec);

u = vec(1);
v = vec(2);
w = vec(3);

m = [u^2+(1-u^2)*cos(ang), u*v*(1-cos(ang))-w*sin(ang), u*w*(1-cos(ang))+v*sin(ang); ...
    u*v*(1-cos(ang))+w*sin(ang), v^2+(1-v^2)*cos(ang), v*w*(1-cos(ang))-u*sin(ang); ...
    u*w*(1-cos(ang))-v*sin(ang), v*w*(1-cos(ang))+u*sin(ang), w^2+(1-w^2)*cos(ang)];

end