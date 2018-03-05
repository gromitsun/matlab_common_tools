function C = fft_convn(A, B, shape)

% not yet correct

if nargin < 3
  shape = 'full';
end

if ~isfloat(A)
    A = double(A);
end
if ~isfloat(B)
    B = double(B);
end

if ~strcmp(shape, 'direct') % padding is needed unless 'direct' method is selected
    sz1 = size(A);
    sz2 = size(B);

    sz = max([sz1; sz2]);

    psz1 = max([sz-sz1; sz2-1]);
    psz2 = max([sz-sz2; sz1-1]);

    A = padarray(A, psz1, 'post');
    B = padarray(B, psz2, 'post');
end


C = ifftn(fftn(A).*fftn(B));

if strcmp(shape, 'same')
    ndim = numel(sz1);
    subs = cell(1,ndim);
    for i = 1:ndim
        subs{i} = (ceil(psz1(i)/2)+1) : (ceil(psz1(i)/2)+sz1(i)); 
    end
    C = C(subs{:});
end


% if strcmp(shape, 'same')
%     subs = num2cell(str2num(num2str([(ceil(psz1(:)/2)+1), (ceil(psz1(:)/2)+sz1(:))], '%d:%d')), 2);
%     C = C(subs{:});
% end