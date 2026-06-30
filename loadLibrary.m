function Library = loadLibrary()
%==============================================================
% loadLibrary
%
% Loads radical library.
% Version 1.0
%==============================================================

%% TEMPOL

R = struct();

R.Name = "TEMPOL";
R.ID = "TEMPOL";
R.Type = "Nitroxide";

%% ---------------- Physical parameters -----------------------

R.Sys = struct();

R.Sys.S = 1/2;
R.Sys.g = 2.0058;
R.Sys.Nucs = '14N';
R.Sys.A = 46.8;          % MHz
R.Sys.lwpp = 0.10;       % mT

%% ---------------- Simulation settings -----------------------

R.Sim = struct();

R.Sim.Method = "garlic";
R.Sim.RangeMargin = 2;

%% ---------------- Fit settings ------------------------------

R.Fit = struct();

R.Fit.Parameters = { ...
    'g', ...
    'A', ...
    'lwpp'};

R.Fit.gLower = -0.005;
R.Fit.gUpper =  0.005;

R.Fit.ALower = -10;
R.Fit.AUpper =  10;

R.Fit.lwLower = 0.05;
R.Fit.lwUpper = 0.50;

%% ---------------- Description -------------------------------

R.Description = "TEMPOL radical";

%% Library

Library = R;

end


