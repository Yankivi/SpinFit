function [B, Signal] = simulateSpectrum(Sys, Exp)

%==========================================================
% Simulate CW EPR spectrum using EasySpin
%==========================================================

%% EasySpin experiment structure

ExpES = struct();

ExpES.mwFreq  = Exp.mwFreq;                 % GHz
ExpES.Range   = [min(Exp.B) max(Exp.B)];    % mT
ExpES.nPoints = Exp.pointsCount;

%% Calculate spectrum

[B, Signal] = garlic(Sys, ExpES);

%% Ensure column vectors

B = B(:);
Signal = Signal(:);

%% Normalize

Signal = Signal - mean(Signal);

m = max(abs(Signal));

if m > 0
    Signal = Signal ./ m;
end

end
