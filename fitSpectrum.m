function Result = fitSpectrum(Exp,Radical)
%==============================================================
% fitSpectrum
%
% Fits one radical from the library to an experimental spectrum.
% Compatible with EasySpin 6.x
%==============================================================

%% Initial parameters

g0 = Radical.Sys.g(:).';
A0 = Radical.Sys.A(:).';

ng = numel(g0);
nA = numel(A0);

x0 = [ ...
    g0 ...
    A0 ...
    Radical.Sys.lwpp ...
    0];     % field shift (mT)

%% Bounds

lb = [ ...
    g0 + Radical.Fit.gLower(:).' ...
    A0 + Radical.Fit.ALower(:).' ...
    Radical.Fit.lwLower ...
   -1];

ub = [ ...
    g0 + Radical.Fit.gUpper(:).' ...
    A0 + Radical.Fit.AUpper(:).' ...
    Radical.Fit.lwUpper ...
    1];

%% Optimization

model = @(p)simulateForFit(p,Exp,Radical,ng,nA);

options = optimoptions('lsqcurvefit', ...
    'Display','iter', ...
    'Algorithm','trust-region-reflective', ...
    'MaxIterations',200, ...
    'MaxFunctionEvaluations',5000);

best = lsqcurvefit( ...
    @(p,~)model(p), ...
    x0, ...
    Exp.Field, ...
    Exp.Signal, ...
    lb, ...
    ub, ...
    options);

%% Final simulation

Calc = model(best);

%% Quality

[RMS,R2,Similarity] = similarityScore(Exp.Signal,Calc);

%% Result structure

Result = struct();

Result.Name = Radical.Name;
Result.Radical = Radical;

Result.g = best(1:ng);

Result.A = best(ng+1:ng+nA);

Result.lwpp = best(ng+nA+1);

Result.shift = best(ng+nA+2);

Result.amplitude = best(ng+nA+3);

Result.Field = Exp.Field;
Result.B = Exp.Field;

Result.Signal = Calc;
Result.RMS = RMS;
Result.R2 = R2;
Result.Similarity = Similarity;
Result.Parameters = table({Result.g},{Result.A},Result.lwpp,Result.shift,Result.amplitude, ...
    'VariableNames',{'g','A_MHz','lwpp','FieldShift','Amplitude'});

end

function Signal = simulateForFit(p,Exp,Radical,ng,nA,expectedN)
if numel(p) ~= expectedN
    error('Fitting parameter vector has %d elements, but %d are required.',numel(p),expectedN);
end

Radical.Sys.g = p(1:ng);
Radical.Sys.A = p(ng+1:ng+nA);
Radical.Sys.lwpp = p(ng+nA+1);
fieldShift = p(ng+nA+2);
amplitude = p(ng+nA+3);

Sim = simulateRadical(Radical,Exp);
Signal = interp1(Sim.Field + fieldShift,Sim.Signal,Exp.Field,'linear',0);
Signal = Signal(:) .* amplitude;
Signal = Signal - mean(Signal);
end

Result.Parameters = table( ...
    {Result.g}, ...
    {Result.A}, ...
    Result.lwpp, ...
    Result.shift, ...
    Result.amplitude, ...
    'VariableNames', ...
    {'g','A_MHz','lwpp','FieldShift','Amplitude'});

function p = applyBounds(p,lb,ub)
p = max(lb,min(ub,p));
end

%======================================================================

function Signal = simulateForFit(p,Exp,Radical,ng,nA)

%% Update radical parameters

Radical.Sys.g = p(1:ng);

Radical.Sys.A = p(ng+1:ng+nA);

Radical.Sys.lwpp = p(ng+nA+1);

fieldShift = p(ng+nA+2);

amplitude = p(ng+nA+3);

%% Simulate

Sim = simulateRadical(Radical,Exp);

%% Shift magnetic field

Signal = interp1( ...
    Sim.RawField + fieldShift,...
    Sim.RawSignal,...
    Exp.Field,...
    'pchip',...
    0);

%% Scale

Signal = Signal .* amplitude;

%% Baseline

Signal = Signal - mean(Signal);

end


