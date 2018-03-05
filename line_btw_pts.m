function out = line_btw_pts(sz, p1, p2)

% draw line between two points p1 and p2
% sz - size of the output boolean array [ny, nx]
% p1, p2 - coordinates of p1 and p2 [y1, x1] [y2, x2]


y1 = p1(2);
y2 = p2(2);
x1 = p1(1);
x2 = p2(1);

if abs(y1-y2)>abs(x1-x2)
    y = round(min(y1,y2)):round(max(y1,y2));
    x = round((y-y1)*(x1-x2)/(y1-y2)+x1);
else
    x = round(min(x1,x2)):round(max(x1,x2));
    y = round((x-x1)*(y1-y2)/(x1-x2)+y1);
end


out = zeros(sz);
out(sub2ind(sz, y(:), x(:))) = 1;

if nargout == 0
    imshow(out);
end

end
    