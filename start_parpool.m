function start_parpool(NumWorkers)

if nargin<1
    NumWorkers = 12;
end

c = parcluster('local');
c.NumWorkers = NumWorkers;
parpool(c, c.NumWorkers);

end