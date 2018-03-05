function [h, hC] = log_image(im, varargin)
% h = log_image(im, varargin)
% where varargin are arguments to be passed to imagesc


%% covert data to log scale
% im is your data
% Rescale data 1-64
im2 = im;
im2(im2<=0)=NaN;
d = log10(im2);
mn = nanmin(d(:));
rng = nanmax(d(:))-mn;
% d = 1+63*(d-mn)/rng; % Self scale data
if nargout
    h = imagesc(d, varargin{:});
else
    imagesc(d, varargin{:});
end

%% set colorbar
hC = colorbar;

%% generate colorbar labels
log_min = floor(mn);
log_max = ceil(mn+rng);
log_rng = log_max-log_min+1;
if rng > 3 % if more than 3 labels
    % L = logspace(log_min, log_max, min(log_rng,10));
    L = log_min:floor(log(log_rng)):log_max;
    l = L; % 1+63*(L-mn)/rng; % Tick mark positions
    L = cellstr(num2str(L(:),'10^{%g}'));
elseif ceil(mn) == floor(mn+rng)
    L = [0.01 0.02 0.05 0.1 0.2 0.5 1 2 5 10 20 50 100 200 500 1000 2000 5000];
    % L = 1:9;
    % L = [L/100, L/10, L, L*10, L*100, L*1000];
    l = log10(L)+log_min; % 1+63*(log10(L)+log_min-mn)/rng; % Tick mark positions
    L = cellstr(num2str(L(:)*(10^log_min),'%g'));
else
    % L = [0.01 0.02 0.05 0.1 0.2 0.5 1 2 5 10 20 50 100 200 500 1000 2000 5000];
    L = 1:9;
    L = [L/100, L/10, L, L*10, L*100, L*1000];
    l = log10(L)+log_min; % 1+63*(log10(L)+log_min-mn)/rng; % Tick mark positions
    L_pos = rem(log10(L),1)==0;
    L2 = cell(1,numel(L));
    L2(L_pos) = cellstr(num2str(log10(L(L_pos))'+log_min,'10^{%g}'));
    L = L2;
end

% Choose appropriate
% or somehow auto generate colorbar labels
set(hC,'Ytick',l,'YTicklabel',L,'FontSize',16,'LineWidth',1);

end