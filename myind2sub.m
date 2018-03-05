function out = myind2sub(siz,ndx)
%IND2SUB Multiple subscripts from linear index.
%   IND2SUB is used to determine the equivalent subscript values
%   corresponding to a given single index into an array.
%
%   [I,J] = IND2SUB(SIZ,IND) returns the arrays I and J containing the
%   equivalent row and column subscripts corresponding to the index
%   matrix IND for a matrix of size SIZ.  
%   For matrices, [I,J] = IND2SUB(SIZE(A),FIND(A>5)) returns the same
%   values as [I,J] = FIND(A>5).
%
%   [I1,I2,I3,...,In] = IND2SUB(SIZ,IND) returns N subscript arrays
%   I1,I2,..,In containing the equivalent N-D array subscripts
%   equivalent to IND for an array of size SIZ.
%
%   Class support for input IND:
%      float: double, single
%      integer: uint8, int8, uint16, int16, uint32, int32, uint64, int64
%
%   See also SUB2IND, FIND.
 
%   Copyright 1984-2015 The MathWorks, Inc. 
lensiz = length(siz);
out = zeros(1,lensiz);

k = cumprod(siz);
for i = lensiz:-1:3,
    vi = rem(ndx-1, k(i-1)) + 1;
    vj = (ndx - vi)/k(i-1) + 1;
    out(i) = double(vj);
    ndx = vi;
end



vi = rem(ndx-1, siz(1)) + 1;
out(2) = double((ndx - vi)/siz(1) + 1);
out(1) = double(vi);

end



