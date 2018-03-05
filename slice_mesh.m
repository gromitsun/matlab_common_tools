function [xyzp] = slice_mesh(p0,nvec,vertices,faces,debug)

% INPUTS
% p0 = point on plane
% nvec = normal vector to plane
% vertices = vertice list
% faces = face list
% debug = debug mode (optional)

% OUTPUT
% xyzp = vertices closest to (or on) plane 

if nargin < 5
    debug = 0;
end

m = size(faces,1);
a = vertices(faces(:,1),:);
b = vertices(faces(:,2),:);
c = vertices(faces(:,3),:);

da = dot((a-repmat(p0,m,1)),repmat(nvec,m,1),2);
db = dot((b-repmat(p0,m,1)),repmat(nvec,m,1),2);
dc = dot((c-repmat(p0,m,1)),repmat(nvec,m,1),2);

k = (da>0)+(db>0)+(dc>0);
k = find((k == 1) | (k == 2));

% edgelist = [];
xyzp = [];
j = 0;

for i = k(1):k(end)
    edgei = [];

    % cross edge ab?
    if (da(i)*db(i)) <= 0
        j = j+1;
        edgei = j;
        t = abs(da(i))/(abs(da(i))+abs(db(i)));
        xyz0 = vertices(faces(i,1),:).*(1-t)+vertices(faces(i,2),:).*t;
        xyzp = [xyzp;xyz0];
    end

    % cross edge ac?
    if (da(i)*dc(i)) <= 0
        j = j+1;
        edgei = [edgei,j];
        t = abs(da(i))/(abs(da(i))+abs(dc(i)));
        xyz0 = vertices(faces(i,1),:).*(1-t)+vertices(faces(i,3),:)*t;
        xyzp = [xyzp;xyz0];
    end

    % cross edge bc?
    if (db(i)*dc(i)) <= 0
        j = j+1;
        edgei = [edgei,j];
        t = abs(db(i))/(abs(db(i))+abs(dc(i)));
        xyz0 = vertices(faces(i,2),:)*(1-t)+vertices(faces(i,3),:)*t;
        xyzp = [xyzp;xyz0];
    end

    % edgelist = [edgelist;edgei];
end

if debug
    hold on
    plot3(vertices(:,1),vertices(:,2),vertices(:,3),'.')
    plot3(p0(1),p0(2),p0(3),'ms')
    plot3(xyzp(:,1),xyzp(:,2),xyzp(:,3),'r.')
    xlabel('x')
    ylabel('y')
    zlabel('z')
    axis equal
    hold off
end

return