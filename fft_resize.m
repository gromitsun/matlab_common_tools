function a = fft_resize(a, ratio)

if all(ratio == 1)
    return;
end

% get size and new size
sz = size(a);
new_sz = round(sz.*ratio);
isodd = rem(sz, 2);
new_isodd = rem(new_sz, 2);

% go to Fourier space
ffta = fftshift(fftn(a));

% resize in Fourier space
if ratio < 1
    cut_before = (sz-new_sz + new_isodd - isodd)/2;
    
    subs = cell(size(sz));
    
    for i = 1:numel(sz)
        subs{i} = (1:new_sz(i)) + cut_before(i);
    end
    
    ffta = ffta(subs{:});
else
    pad_before = -(sz-new_sz + new_isodd - isodd)/2;
    pad_after = new_sz - sz - pad_before;
    
    ffta = padarray(padarray(ffta, pad_before, 'pre'), pad_after, 'post');
end

a = ifftn(fftshift(ffta), 'symmetric') * prod(new_sz) / prod(sz);
    
