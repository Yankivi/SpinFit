function Exp = loadJSONSpectrum(filename)

raw = jsondecode(fileread(filename));

%% Experiment parameters

common = raw.ExperimentOptions.CommonOptions;

Exp.centerField = common.CenterMagneticField;
Exp.sweepWidth  = common.SweepWidth;
Exp.pointsCount = common.PointsCount;

Exp.modAmp = common.ModulationAmplitude;
Exp.power  = common.MwParameter.PowerMW;

Exp.mwFreq = raw.MwFrequencyKHz / 1e6;

%% Magnetic field axis

Exp.B = linspace( ...
    Exp.centerField - Exp.sweepWidth/2, ...
    Exp.centerField + Exp.sweepWidth/2, ...
    Exp.pointsCount)';

%% Signal

curve = raw.Values.Values;

signal = zeros(Exp.pointsCount,1);

for k = 1:Exp.pointsCount
    signal(k) = curve(k).Points(1);
end

%% Remove DC offset

signal = signal - mean(signal);

%% Normalize

signal = signal ./ max(abs(signal));

%% Store

Exp.signal = signal;

%% Optional metadata

Exp.phase      = raw.PhaseRadians;
Exp.noiseLevel = raw.NoiseLevel;
Exp.peaks      = raw.Peaks;
Exp.Q          = raw.QValue;

end
