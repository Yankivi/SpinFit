function Exp = loadSpectrumJSON(filename)
% ============================================================
% loadSpectrumJSON
% Loads EPR spectrum from e-Spinoza JSON format
% ============================================================

if nargin==0
    [file,path] = uigetfile('*.json','Select spectrum');
    if isequal(file,0)
        error('No file selected.');
    end
    filename = fullfile(path,file);
end

txt = fileread(filename);
raw = jsondecode(txt);

%% ---------- Experimental parameters ----------

opt = raw.ExperimentOptions.CommonOptions;

Exp.FileName = filename;

Exp.CenterField = opt.CenterMagneticField;     % mT
Exp.SweepWidth = opt.SweepWidth;               % mT
Exp.PointsCount = opt.PointsCount;

Exp.StartField = Exp.CenterField - Exp.SweepWidth/2;
Exp.EndField   = Exp.CenterField + Exp.SweepWidth/2;

Exp.ModAmp = opt.ModulationAmplitude;
Exp.Power = opt.MwParameter.PowerMW;
Exp.Attenuation = opt.MwParameter.AttenuationDb;

%% ---------- Spectrum ----------

curve = raw.Values(1);

pts = curve.Values;

N = length(pts);

signal = zeros(N,1);

for k = 1:N
    signal(k) = pts(k).Points(2);
end

field = linspace(Exp.StartField,...
                 Exp.EndField,...
                 N).';

%% ---------- Normalize ----------

signal = signal - mean(signal);

mx = max(abs(signal));

if mx~=0
    signal = signal/mx;
end

%% ---------- Store ----------

Exp.Field = field;
Exp.Signal = signal;

Exp.FrequencyGHz = curve.MwFrequencyKHz/1e6;

Exp.Noise = curve.NoiseLevel;

Exp.Q = curve.QValue;

Exp.Temperature = curve.CavityTemperature;

%% ---------- Peaks ----------

if isfield(curve,'Peaks')

    pk = curve.Peaks;

    Exp.Peaks = [];

    for i=1:length(pk)

        Exp.Peaks(i).Left = pk(i).Left;
        Exp.Peaks(i).Right = pk(i).Right;

    end

else

    Exp.Peaks=[];

end

%% ---------- PMC ----------

if isfield(curve,'PMC')

    Exp.PMC = curve.PMC;

else

    Exp.PMC=[];

end

%% ---------- Plot ----------

figure('Name','Loaded spectrum');

plot(field,signal,'k','LineWidth',1.2)

xlabel('Magnetic field (mT)')
ylabel('Normalized intensity')

grid on
box on

end
