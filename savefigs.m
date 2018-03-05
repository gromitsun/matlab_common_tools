function savefigs(varargin)

p = inputParser;
p.addParameter('prefix', '', @isstr);
p.addParameter('suffix', '', @isstr);
p.addParameter('fmt', 'pdf', @isstr);
p.addParameter('handles', get(0, 'Children'));

parse(p, varargin{:});

% the following three have equivalent effects
% handles = get(0, 'Children');
% handles = findobj('Type','figure');
% handles = findall(0,'Type','figure');

prefix = p.Results.prefix;
suffix = p.Results.suffix;
fmt = p.Results.fmt;
hs = p.Results.handles;


for i = 1:numel(hs)
    h = hs(i);
    savename = sprintf(strcat(prefix,h.Name,suffix), h.Number);
    fprintf('Saving figure %g to %s ...\n', i, savename);
    h.Units = 'inches';
    h.PaperUnits = 'inches';
    h.PaperSize = [h.Position(3) h.Position(4)];
    h.PaperPosition = [0 0 h.Position(3) h.Position(4)];
    saveas(h, savename, fmt);
end

fprintf('Saved %d figures to file.\n', numel(hs));

end
    
