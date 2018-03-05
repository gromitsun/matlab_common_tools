function out = getbytes(in)
% Get memory usage of the variable in bytes.
% "in" can be either object or string of typename 
% (e.g. 'single', 'double', 'int32', etc.)

if isa(in, 'char')
	in = feval(in,0);
end

s = whos('in');

out = s.bytes;

end