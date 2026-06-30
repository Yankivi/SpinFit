function [RMS,R2,Similarity] = similarityScore(ExpSignal,SimSignal)
%==============================================================
% similarityScore
%
% Calculates similarity between experimental and simulated
% EPR spectra.
%
% OUTPUT
%   RMS
%   R2
%   Similarity (0...100 %)
%==============================================================

%% Column vectors

ExpSignal = ExpSignal(:);
SimSignal = SimSignal(:);

%% Remove baseline

ExpSignal = ExpSignal - mean(ExpSignal);
SimSignal = SimSignal - mean(SimSignal);

%% Normalize

if max(abs(ExpSignal))>0
    ExpSignal = ExpSignal/max(abs(ExpSignal));
end

if max(abs(SimSignal))>0
    SimSignal = SimSignal/max(abs(SimSignal));
end

%% RMS

Residual = ExpSignal - SimSignal;

RMS = sqrt(mean(Residual.^2));

%% R²

SSres = sum(Residual.^2);

SStot = sum((ExpSignal-mean(ExpSignal)).^2);

if SStot==0
    R2 = 1;
else
    R2 = 1 - SSres/SStot;
end

%% Pearson correlation

C = corrcoef(ExpSignal,SimSignal);

if numel(C)==4
    Corr = C(1,2);
else
    Corr = 0;
end

%% Similarity

Similarity = max(0,min(100,100*Corr));

end


