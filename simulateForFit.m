function Signal = simulateForFit(p,Exp,Sys)
%==========================================================
% simulateForFit
%
% Simulates a spectrum during nonlinear fitting.
%
% p =
% [ g
%   A
%   lwpp
%   FieldShift ]
%==========================================================

%% Update radical parameters

Sys.g    = p(1);
Sys.A    = p(2);
Sys.lwpp = p(3);

FieldShift = p(4);

%% Simulate spectrum

[B,Signal] = simulateSpectrum(Sys,Exp);

%% Shift magnetic field

B = B + FieldShift;

%% Interpolate onto experimental magnetic field axis

Signal = interp1( ...
    B,...
    Signal,...
    Exp.B,...
    'pchip',...
    0);

%% Normalize

Signal = normalizeSignal(Signal);

%% Ensure column vector

Signal = Signal(:);

end


