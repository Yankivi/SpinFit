function value = scalarOrDefault(S,fieldName,defaultValue)
% scalarOrDefault Returns the first scalar field value or a default.

if isfield(S,fieldName) && ~isempty(S.(fieldName))
    value = S.(fieldName);
    value = value(1);
else
    value = defaultValue;
end
end
