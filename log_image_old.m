function log_image(im)

% source: http://www.mathworks.com/matlabcentral/answers/100066#answer_109414


% im is your data
% Rescale data 1-64
im2 = im;
im2(im2<=0)=NaN;
d = log10(im2);
mn = nanmin(d(:));
rng = nanmax(d(:))-mn;
d = 1+63*(d-mn)/rng; % Self scale data
imagesc(d);
hC = colorbar;
L = [0.01 0.02 0.05 0.1 0.2 0.5 1 2 5 10 20 50 100 200 500 1000 2000 5000];
% Choose appropriate
% or somehow auto generate colorbar labels
l = 1+63*(log10(L)-mn)/rng; % Tick mark positions
set(hC,'Ytick',l,'YTicklabel',L);

end