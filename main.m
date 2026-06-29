%% ==========================================================
% SpinFit PoC
% Load a TEMPOL spectrum, identify the closest library radical,
% fit its parameters, and report similarity metrics.
%===========================================================

clear;
clc;
close all;

addpath(genpath(pwd));

[file,path] = uigetfile('*.json','Select E-Spinosa spectrum');

if isequal(file,0)
    disp('No file selected.');
    return;
end

Exp = loadJSONSpectrum(fullfile(path,file));
Library = loadLibrary();

InitialMatch = identifyBestRadical(Exp,Library);
Result = fitSpectrum(Exp,InitialMatch.Radical);

plotComparison(Exp,Result);

fprintf('\n');
fprintf('=============================================\n');
fprintf('              SPINFIT RESULT\n');
fprintf('=============================================\n\n');

fprintf('Identified Radical : %s\n\n',Result.Name);

fprintf('Optimized Parameters\n');
fprintf('---------------------------------------------\n');
fprintf('g tensor           : %s\n',mat2str(Result.g,6));
fprintf('Hyperfine A (MHz)  : %s\n',mat2str(Result.A,6));
fprintf('Line Width (mT)    : %.4f\n',Result.lwpp);
fprintf('Field Shift (mT)   : %.4f\n',Result.shift);
fprintf('Amplitude          : %.4f\n\n',Result.amplitude);

fprintf('Fit Quality\n');
fprintf('---------------------------------------------\n');
fprintf('Initial Similarity : %.2f %%\n',InitialMatch.Score);
fprintf('Fitted Similarity  : %.2f %%\n',Result.Similarity);
fprintf('RMS Error          : %.6f\n',Result.RMS);
fprintf('R^2                : %.6f\n',Result.R2);

fprintf('\n=============================================\n');
fprintf('Fit completed successfully.\n');
fprintf('=============================================\n');
