function Signal = normalizeSignal(Signal)
% normalizeSignal Removes DC offset and scales a vector to max absolute value 1.

Signal = Signal(:);
Signal = Signal - mean(Signal);
mx = max(abs(Signal));

if mx ~= 0
    Signal = Signal ./ mx;
end

end
