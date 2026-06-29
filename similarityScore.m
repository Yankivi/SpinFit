function [RMS, R2, Similarity] = similarityScore(ExpSignal, CalcSignal)

%==========================================================
% Calculate fit quality metrics
%
% Inputs:
%   ExpSignal  - Experimental spectrum
%   CalcSignal - Simulated spectrum
%
% Outputs:
%   RMS         - Root Mean Square Error
%   R2          - Coefficient of determination
%   Similarity  - Similarity in %
%==========================================================

%% Column vectors

ExpSignal = ExpSignal(:);
CalcSignal = CalcSignal(:);

%% Remove DC offset

ExpSignal = ExpSignal - mean(ExpSignal);
CalcSignal = CalcSignal - mean(CalcSignal);

%% Normalize

ExpMax = max(abs(ExpSignal));
CalcMax = max(abs(CalcSignal));

if ExpMax > 0
    ExpSignal = ExpSignal / ExpMax;
end

if CalcMax > 0
    CalcSignal = CalcSignal / CalcMax;
end

%% Residual

Residual = ExpSignal - CalcSignal;

%% RMS

RMS = sqrt(mean(Residual.^2));

%% R²

SSres = sum(Residual.^2);
SStot = sum((ExpSignal - mean(ExpSignal)).^2);

if SStot == 0
    R2 = 1;
else
    R2 = 1 - SSres/SStot;
end

%% Pearson correlation

R = corrcoef(ExpSignal, CalcSignal);

if numel(R) < 4 || any(isnan(R(:)))
    corrValue = 0;
else
    corrValue = R(1,2);
end

%% Similarity (%)

Similarity = max(0, min(100, corrValue * 100));

end
