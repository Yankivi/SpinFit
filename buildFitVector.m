function [x0,lb,ub] = buildFitVector(values,lowerDelta,upperDelta,defaultDelta)
% buildFitVector Builds start/lower/upper vectors for one fit parameter group.

values = values(:).';
if isempty(values)
    values = 0;
end

lowerDelta = expandFitDelta(lowerDelta,numel(values),-defaultDelta);
upperDelta = expandFitDelta(upperDelta,numel(values), defaultDelta);

x0 = values;
lb = values + lowerDelta;
ub = values + upperDelta;
end
