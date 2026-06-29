function Sys = loadTEMPOL()

%==========================================================
% TEMPOL Radical Library Entry
%==========================================================

Sys.Name = 'TEMPOL';

%% Electron spin

Sys.S = 1/2;

%% Isotropic g-factor

Sys.g = 2.0059;

%% Hyperfine interaction

Sys.Nucs = '14N';

Sys.A = 47.0;                 % MHz

%% Line shape

Sys.lwpp = 0.18;              % mT (peak-to-peak Lorentzian)

%% Spin system options

Sys.weight = 1;

Sys.gStrain = [];

Sys.AStrain = [];

Sys.HStrain = [];

Sys.lw = [];

Sys.lwEndor = [];

%% Initial fitting parameters

Sys.FieldShift = 0.0;         % mT

Sys.Amplitude = 1.0;

End
