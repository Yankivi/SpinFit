function Exp = loadJSONSpectrum(filename)
% loadJSONSpectrum Loads an EPR spectrum from e-Spinoza JSON format.

if nargin==0 || isempty(filename)
    [file,path] = uigetfile('*.json','Select spectrum');
    if isequal(file,0)
        error('No file selected.');
    end
    filename = fullfile(path,file);
end

%% Read JSON
txt = fileread(filename);
raw = jsondecode(txt);

%% Experiment parameters
opt = raw.ExperimentOptions.CommonOptions;

Exp.FileName      = filename;
Exp.CenterField   = opt.CenterMagneticField;      % mT
Exp.SweepWidth    = opt.SweepWidth;               % mT
Exp.PointsCount   = opt.PointsCount;
Exp.StartField    = Exp.CenterField - Exp.SweepWidth/2;
Exp.EndField      = Exp.CenterField + Exp.SweepWidth/2;

Exp.ModAmp        = opt.ModulationAmplitude;
Exp.Power         = opt.MwParameter.PowerMW;
Exp.Attenuation   = opt.MwParameter.AttenuationDb;

%% Spectrum
curve = raw.Values(1);
pts = curve.Values;

N = length(pts);

signal = zeros(N,1);

for k = 1:N
    signal(k) = pts(k).Points(2);   % Intensity
end

field = linspace(Exp.StartField,Exp.EndField,N).';

signal = normalizeSignal(signal);

Exp.Field  = field;
Exp.Signal = signal;

%% Compatibility with prototype
Exp.B = Exp.Field;
Exp.signal = Exp.Signal;

%% Instrument parameters (stored in TOP LEVEL of JSON)
if isfield(raw,'MwFrequencyKHz')
    Exp.FrequencyGHz = raw.MwFrequencyKHz/1e6;
else
    Exp.FrequencyGHz = NaN;
end

if isfield(raw,'NoiseLevel')
    Exp.Noise = raw.NoiseLevel;
else
    Exp.Noise = NaN;
end

if isfield(raw,'QValue')
    Exp.Q = raw.QValue;
else
    Exp.Q = NaN;
end

if isfield(raw,'CavityTemperature')
    Exp.Temperature = raw.CavityTemperature;
else
    Exp.Temperature = NaN;
end

%% Peaks
if isfield(raw,'Peaks')
    pk = raw.Peaks;

    Exp.Peaks = struct([]);

    for i = 1:length(pk)
        Exp.Peaks(i).Left  = pk(i).Left;
        Exp.Peaks(i).Right = pk(i).Right;
    end
else
    Exp.Peaks = [];
end

%% Paramagnetic center information
if isfield(raw,'PMC')
    Exp.PMC = raw.PMC;
else
    Exp.PMC = [];
end

%% Plot
figure('Name','Loaded spectrum');

plot(field,signal,'k','LineWidth',1.2);

xlabel('Magnetic field (mT)');
ylabel('Normalized intensity');

grid on;
box on;

end


