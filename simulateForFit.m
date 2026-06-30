function Signal = simulateForFit(p,Exp,Radical,ng,nA,expectedN)
% simulateForFit Updates a library radical from optimizer parameters.

if numel(p) ~= expectedN
    error('Fitting parameter vector has %d elements, but %d are required.',numel(p),expectedN);
end

Radical.Sys.g = p(1:ng);
Radical.Sys.A = p(ng+1:ng+nA);
Radical.Sys.lwpp = p(ng+nA+1);
fieldShift = p(ng+nA+2);
amplitude = p(ng+nA+3);

Sim = simulateRadical(Radical,Exp);
Signal = interp1(Sim.Field + fieldShift,Sim.Signal,Exp.Field,'linear',0);
Signal = Signal(:) .* amplitude;
Signal = Signal - mean(Signal);
end
