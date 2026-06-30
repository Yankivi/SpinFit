function delta = expandFitDelta(delta,n,defaultValue)
% expandFitDelta Expands empty/scalar fit deltas to a row vector of length n.

if isempty(delta)
    delta = defaultValue * ones(1,n);
else
    delta = delta(:).';
    if numel(delta) == 1 && n > 1
        delta = repmat(delta,1,n);
    end
end

if numel(delta) ~= n
    error('Fit bound length mismatch: got %d values, expected %d.',numel(delta),n);
end
end
