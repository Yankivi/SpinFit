function Library = loadLibrary()
%==============================================================
% loadLibrary
% Loads radical library.
% Version 1.0 (TEMPOL only)
%==============================================================

Library = struct([]);

%% ============================================================
% TEMPOL
% =============================================================

R.Name = "TEMPOL";
R.ID = "TEMPOL";
R.Type = "Nitroxide";

%---------------- Electron spin -------------------------------

R.Sys.S = 1/2;

%---------------- g tensor ------------------------------------

R.Sys.g = [2.0093 2.0061 2.0022];

%---------------- Hyperfine -----------------------------------

R.Sys.Nucs = '14N';
R.Sys.n = 1;
R.Sys.A = [20 20 100];      % MHz

%---------------- Line width ----------------------------------

R.Sys.lwpp = 0.18;

%---------------- Optional parameters -------------------------

R.Sys.weight = 1;

R.Sys.gStrain = [];
R.Sys.AStrain = [];
R.Sys.HStrain = [];
R.Sys.lw = [];
R.Sys.Exchange = [];

%---------------- Simulation settings -------------------------

R.Sim.Method = "garlic";
R.Sim.RangeMargin = 2;

%---------------- Parameters allowed for fitting --------------

R.Fit.Parameters = { ...
    'g', ...
    'A', ...
    'lwpp'};

R.Fit.gLower = [-0.002 -0.002 -0.002];
R.Fit.gUpper = [ 0.002  0.002  0.002];

R.Fit.ALower = [-5 -5 -10];
R.Fit.AUpper = [ 5  5  10];

R.Fit.lwLower = 0.05;
R.Fit.lwUpper = 1.00;

%---------------- Description ---------------------------------

R.Description = "TEMPOL radical";

Library(end+1) = R;

end
