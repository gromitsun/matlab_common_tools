function out = fft_xcorrn(A, B, shape)

%% Parsing arguments
if nargin < 3
  shape = 'full';
end
if nargin < 2
    B = [];
end

if ~isfloat(A)
    A = double(A);
end
if ~isfloat(B)
    B = double(B);
end

%% Correlation types
if isempty(B)
%% Auto-correlation
    if ~strcmp(shape, 'direct') % padding is needed unless 'direct' method is selected
        sz1 = size(A);
        psz1 = sz1-1;
        A = padarray(A, psz1, 'post');
    end

    out = fftshift(ifftn(abs(fftn(A)).^2, 'symmetric'));

    if strcmp(shape, 'same')
        ndim = numel(sz1);
        subs = cell(1,ndim);
        for i = 1:ndim
            subs{i} = (ceil(psz1(i)/2)+1) : (ceil(psz1(i)/2)+sz1(i)); 
        end
        out = out(subs{:});
    end

else
%% Cross-correlation
    if ~strcmp(shape, 'direct') % padding is needed unless 'direct' method is selected
        sz1 = size(A);
        sz2 = size(B);

        sz = max([sz1; sz2]);

        psz1 = max([sz-sz1; sz2-1]);
        psz2 = max([sz-sz2; sz1-1]);

        A = padarray(A, psz1, 'post');
        B = padarray(B, psz2, 'post');
    end

    out = fftshift(ifftn(conj(fftn(B)).*fftn(A), 'symmetric'));

    if strcmp(shape, 'same')
        ndim = numel(sz1);
        subs = cell(1,ndim);
        for i = 1:ndim
            subs{i} = (ceil(psz1(i)/2)+1) : (ceil(psz1(i)/2)+sz1(i)); 
        end
        out = out(subs{:});
    end
end

end