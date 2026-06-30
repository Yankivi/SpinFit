function Sim = simulateRadical(Radical,Exp)
%==============================================================
% simulateRadical
%
% Simulates an EPR spectrum using EasySpin.
%
% INPUT
%   Radical - library radical
%   Exp     - experimental spectrum
%
% OUTPUT
%   Sim.RawField   - EasySpin magnetic field axis
%   Sim.RawSignal  - EasySpin simulated spectrum
%   Sim.Field      - interpolated field axis
%   Sim.Signal     - interpolated spectrum
%==============================================================

%% Simulation settings

ExpSim = struct();

ExpSim.mwFreq   = Exp.FrequencyGHz;
ExpSim.Range    = [Exp.StartField Exp.EndField];
ExpSim.nPoints  = max(4096,length(Exp.Field));
ExpSim.Harmonic = 1;

%% Run EasySpin

switch lower(string(Radical.Sim.Method))

    case "garlic"

        [B,spc] = garlic(Radical.Sys,ExpSim);
        spc = -spc;

    case "pepper"

        [B,spc] = pepper(Radical.Sys,ExpSim);

    otherwise

        error("Unknown simulation method.");

end

%% Prepare spectrum

B = B(:);
spc = spc(:);

spc = spc - mean(spc);

if max(abs(spc))>0
    spc = spc/max(abs(spc));
end

%% Interpolate to experiment

Signal = interp1( ...
    B,...
    spc,...
    Exp.Field,...
    'pchip',...
    0);

Signal = Signal - mean(Signal);

if max(abs(Signal))>0
    Signal = Signal/max(abs(Signal));
end

%% Output

Sim = struct();

Sim.Name = Radical.Name;

Sim.RawField = B;
Sim.RawSignal = spc;

Sim.Field = Exp.Field;
Sim.Signal = Signal;

end


