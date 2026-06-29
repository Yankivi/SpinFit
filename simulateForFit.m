
function Signal = simulateForFit(p, Exp)

%==========================================================
% Simulate spectrum for fitting
%
% p =
% [ g
%   A
%   lwpp
%   FieldShift
%   Amplitude ]
%==========================================================

%% Load reference radical

Sys = loadTEMPOL();

%% Update fitting parameters

Sys.g    = p(1);
Sys.A    = p(2);
Sys.lwpp = p(3);

FieldShift = p(4);
Amplitude  = p(5);

%% Simulate spectrum

[B, Signal] = simulateSpectrum(Sys, Exp);

%% Apply magnetic field shift

B = B + FieldShift;

%% Interpolate onto experimental field axis

Signal = interp1( ...
    B, ...
    Signal, ...
    Exp.B, ...
    'linear', ...
    0);

%% Apply amplitude

Signal = Amplitude * Signal;

%% Remove DC offset

Signal = Signal - mean(Signal);

%% Normalize

m = max(abs(Signal));

if m > 0
    Signal = Signal ./ m;
end

%% Return column vector

Signal = Signal(:);

End
