function p = applyBounds(p,lb,ub)
% applyBounds Clips optimizer parameters into lower/upper bounds.

p = max(lb,min(ub,p));
end
