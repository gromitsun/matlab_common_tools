function [newVertices, newFaces] = remove_fv(vertices, faces, verticesToRemove)

% Convert true indexing to logical indexing
if ~islogical(verticesToRemove)
    verticesToKeep = zeros([size(vertices, 1), 1], 'logical');
    verticesToKeep(verticesToRemove) = 1;
else
    verticesToKeep = ~verticesToRemove;
end

% Remove the vertex values at the specified index values
newVertices = vertices(verticesToKeep,:);

% Find the new indices of vertices
newIndices = nan([size(vertices, 1), 1]);
newIndices(verticesToKeep) = 1:size(newVertices, 1);

% Find any faces that used the vertices that we removed and remove them
% Then update the vertex indices to the new ones
newFaces = newIndices(faces(all(verticesToKeep(faces), 2), :));


%% Struct version
% function FV = remove_fv(FV, verticesToRemove)
% 
% % Convert true indexing to logical indexing
% if ~islogical(verticesToRemove)
%     verticesToKeep = zeros([size(fv.vertices, 1), 1], 'logical');
%     verticesToKeep(verticesToRemove) = 1;
% else
%     verticesToKeep = ~verticesToRemove;
% end
% 
% % Remove the vertex values at the specified index values
% newVertices = fv.vertices(verticesToKeep,:);
% 
% % Find the new indices of vertices
% newIndices = nan([size(fv.vertices, 1), 1]);
% newIndices(verticesToKeep) = 1:size(newVertices, 1);
% 
% % Find any faces that used the vertices that we removed and remove them
% % Then update the vertex indices to the new ones
% newFaces = newIndices(fv.faces(all(verticesToKeep(fv.faces), 2), :));
% 
% FV.vertices = newVertices;
% FV.faces = newFaces;