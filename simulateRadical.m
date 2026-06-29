function Sim = simulateRadical(Radical,Exp)
%==============================================================
% simulateRadical
%
% Simulates EPR spectrum for one radical from the library.
%
% INPUT
%   Radical   - element of Library
%   Exp        - experimental spectrum structure
%
% OUTPUT
%   Sim.Field
%   Sim.Signal
%==============================================================

if ~exist('garlic','file')
    error(['EasySpin is not installed or not added to MATLAB path.' ...
           newline ...
           'Function garlic() was not found.']);
end

%% -------------------------------------------------------------
% Experimental parameters
%% -------------------------------------------------------------

ExpSim = struct();

ExpSim.mwFreq = Exp.FrequencyGHz;
ExpSim.CenterSweep = [Exp.CenterField Exp.SweepWidth];
ExpSim.nPoints = length(Exp.Field);

%% -------------------------------------------------------------
% Simulate
%% -------------------------------------------------------------

switch lower(Radical.Sim.Method)

    case "garlic"

        [B,spc] = garlic(Radical.Sys,ExpSim);

    case "pepper"

        [B,spc] = pepper(Radical.Sys,ExpSim);

    otherwise

        error("Unknown simulation method.");

end

%% -------------------------------------------------------------
% Normalize
%% -------------------------------------------------------------

spc = spc(:);

spc = spc - mean(spc);

m = max(abs(spc));

if m~=0
    spc = spc./m;
end

%% -------------------------------------------------------------
% Interpolate to experimental field axis
%% -------------------------------------------------------------

spcInterp = interp1( ...
    B(:), ...
    spc(:), ...
    Exp.Field, ...
    'linear', ...
    0);

%% -------------------------------------------------------------
% Normalize again
%% -------------------------------------------------------------

spcInterp = spcInterp - mean(spcInterp);

m = max(abs(spcInterp));

if m~=0
    spcInterp = spcInterp./m;
end

%% -------------------------------------------------------------
% Result
%% -------------------------------------------------------------

Sim = struct();

Sim.Name = Radical.Name;

Sim.Field = Exp.Field;

Sim.Signal = spcInterp;

Sim.RawField = B;

Sim.RawSignal = spc;

end
