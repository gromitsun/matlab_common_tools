function seg_idx = nth_conncomp(im, nth)
%nth_conncomp Find the nth largest connected component in im.
%   Find the nth largest connected component in im, where im is an N-d
%   array. Return the logic map with the desired component being 1 and
%   others being zero. Default of nth is 1.

if nargin < 1
    nth = 1;
end

% label segmented regions
CC = bwconncomp(im);
L = labelmatrix(CC);

% find largest connected region, i.e. the main dendrite
% (the region labelled 0 is the background, which is excluded in histcounts)
L_hist = histcounts(L(L>0), CC.NumObjects);
[~, idx] = sort(L_hist(:),'descend');
% seg_idx = (L == idx(nth));
seg_idx = ismember(L, idx(nth(:)));
end


%% old version with background label = 1
function seg_idx = nth_conncomp_old(im, nth)
%nth_conncomp Find the nth largest connected component in im.
%   Find the nth largest connected component in im, where im is an N-d
%   array. Return the logic map with the desired component being 1 and
%   others being zero. Default of nth is 2.

if nargin < 2
    nth = 2;
end

% label segmented regions
CC = bwconncomp(im);
L = labelmatrix(CC);

% find second largest connected region, i.e. the main dendrite
L_hist = histcounts(L, CC.NumObjects+1);
[~, idx] = sort(L_hist(:),'descend');
% seg_idx = (L == (idx(nth) - 1));
seg_idx = ismember(L, (idx(nth(:)) - 1));
end