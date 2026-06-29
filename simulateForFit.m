function Signal = simulateForFit(p,Exp,Sys)

%==========================================================
% Simulate spectrum for fitting
%
% INPUT
%   p
%   Exp
%   Sys
%
% p =
% [ g
%   A
%   lwpp
%   FieldShift
%   Amplitude ]
%
%==========================================================

%% Update radical parameters

Sys.g = p(1);
Sys.A = p(2);
Sys.lwpp = p(3);

FieldShift = p(4);
Amplitude = p(5);

%% Simulate spectrum

[B,Signal] = simulateSpectrum(Sys,Exp);

%% Shift magnetic field

B = B + FieldShift;

%% Interpolate

Signal = interp1( ...
    B,...
    Signal,...
    Exp.B,...
    'linear',...
    0);

%% Amplitude correction

Signal = Signal .* Amplitude;

%% Remove DC

Signal = Signal - mean(Signal);

%% Normalize

m = max(abs(Signal));

if m~=0
    Signal = Signal./m;
end

Signal = Signal(:);

end
