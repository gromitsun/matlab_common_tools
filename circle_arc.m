function out = circle_arc(nx, ny, r, xc, yc, theta)


sz = [ny, nx]; % column major

dtheta = asin(1/r);
th = theta(1):dtheta:theta(2);

x = round(xc + r * cos(th));
y = round(yc - r * sin(th));

valid = (x>0) & (x<nx) & (y>0) & (y<ny);

x = x(valid);
y = y(valid);

out = zeros(sz);
out(sub2ind(sz, y(:), x(:))) = 1;

if nargout == 0
    imshow(out);
end

end


