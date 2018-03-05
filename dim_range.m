function out = dim_range(A)
%dim_range Find the index range of non-zero values in N-d array A.
%   Find the index range of non-zero values in N-d array A. Return the
%   lower and higher limits of each dimension in sequence.

% check if A is all zeros
if ~any(A(:))
    out = [];
    warning('Input array is all zeros!');
    return;
end

% Init array for output
out = NaN(1, ndims(A));

% Loop over all dims
for dim = 1:ndims(A)
    
    % Find first non-zero
    for i = 1:size(A, dim)
        A_slice = ndslice(A, i, dim);
        if any(A_slice(:))
            out(2*dim-1) = i;
            break
        end
    end % End first NZ
    
    % Find last non-zero
    for i = size(A, dim):-1:out(2*dim-1)
        A_slice = ndslice(A, i, dim);
        if any(A_slice(:))
            out(2*dim) = i;
            break
        end
    end % End last NZ
    
end % End loop over dims

end


