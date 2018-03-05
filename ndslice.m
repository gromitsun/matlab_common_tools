function out = ndslice(A, ix, dim)
%ndslice Dynamic array slicing.
%   Equivalent to
%           out = A(:, :, ..., ix, :, :,...:);
%                   ^  ^        ^  ^  
%   dimensions -->  1  2       dim dim+1
%
%  Each row of ix corresponds to one slicing dimension 
%  as specified in dim. (size(ix, 1) == length(dim))
%  Each column of ix represents one slicing index in that dimension.

subses = repmat({':'}, [1 ndims(A)]);
if length(dim) > 1
    for i = 1:length(dim)
        subses{dim(i)} = ix(i,:);
    end
else
    subses{dim} = ix;
end
out = A(subses{:});

end