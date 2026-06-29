function Exp = loadJSONSpectrum(filename)
% loadJSONSpectrum Loads an EPR spectrum from e-Spinoza JSON format.

if nargin==0 || isempty(filename)
    [file,path] = uigetfile('*.json','Select spectrum');
    if isequal(file,0)
        error('No file selected.');
    end
    filename = fullfile(path,file);
end

txt = fileread(filename);
raw = jsondecode(txt);

opt = raw.ExperimentOptions.CommonOptions;

Exp.FileName = filename;
Exp.CenterField = opt.CenterMagneticField;     % mT
Exp.SweepWidth = opt.SweepWidth;               % mT
Exp.PointsCount = opt.PointsCount;
Exp.StartField = Exp.CenterField - Exp.SweepWidth/2;
Exp.EndField = Exp.CenterField + Exp.SweepWidth/2;
Exp.ModAmp = opt.ModulationAmplitude;
Exp.Power = opt.MwParameter.PowerMW;
Exp.Attenuation = opt.MwParameter.AttenuationDb;

curve = raw.Values(1);
pts = curve.Values;
N = length(pts);
signal = zeros(N,1);

for k = 1:N
    signal(k) = pts(k).Points(2);
end

field = linspace(Exp.StartField,Exp.EndField,N).';
signal = normalizeSignal(signal);

Exp.Field = field;
Exp.Signal = signal;

% Backward-compatible aliases used by the original prototype scripts.
Exp.B = Exp.Field;
Exp.signal = Exp.Signal;

Exp.FrequencyGHz = curve.MwFrequencyKHz/1e6;
Exp.Noise = curve.NoiseLevel;
Exp.Q = curve.QValue;
Exp.Temperature = curve.CavityTemperature;

if isfield(curve,'Peaks')
    pk = curve.Peaks;
    Exp.Peaks = [];
    for i=1:length(pk)
        Exp.Peaks(i).Left = pk(i).Left;
        Exp.Peaks(i).Right = pk(i).Right;
    end
else
    Exp.Peaks = [];
end

if isfield(curve,'PMC')
    Exp.PMC = curve.PMC;
else
    Exp.PMC = [];
end

figure('Name','Loaded spectrum');
plot(field,signal,'k','LineWidth',1.2)
xlabel('Magnetic field (mT)')
ylabel('Normalized intensity')
grid on
box on

end
