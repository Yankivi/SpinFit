%% ==========================================================
% SpinFit PoC
% Main program
%===========================================================

clear;
clc;
close all;

%% Add project folders

addpath(genpath(pwd));

%% Select experimental spectrum

[file,path] = uigetfile('*.json','Select E-Spinosa spectrum');

if isequal(file,0)
    disp('No file selected.');
    return;
end

filename = fullfile(path,file);

%% Load experimental spectrum

Exp = loadJSONSpectrum(filename);

%% Load radical from library

Sys = loadTEMPOL();

%% Initial simulation

[B0,Sim0] = simulateSpectrum(Sys,Exp);

%% Plot initial comparison

figure('Name','SpinFit PoC','Color','w');

subplot(2,1,1)

plot(Exp.B,Exp.signal,'k','LineWidth',1.5);
hold on
plot(B0,Sim0,'r','LineWidth',1.5);

grid on
xlabel('Magnetic Field (mT)');
ylabel('Intensity');
title('Initial Simulation');
legend('Experiment','Library TEMPOL','Location','best');

%% Automatic fitting

Result = fitTEMPOL(Exp,Sys);

%% Plot fitted spectrum

subplot(2,1,2)

plot(Exp.B,Exp.signal,'k','LineWidth',1.5);
hold on
plot(Result.B,Result.Signal,'r','LineWidth',1.5);

grid on
xlabel('Magnetic Field (mT)');
ylabel('Intensity');

title(sprintf('Fit Result   Similarity = %.2f %%',Result.Similarity));

legend('Experiment','Fitted TEMPOL','Location','best');

%% Console report

fprintf('\n');
fprintf('=============================================\n');
fprintf('              SPINFIT RESULT\n');
fprintf('=============================================\n\n');

fprintf('Identified Radical : %s\n\n',Result.Name);

fprintf('Optimized Parameters\n');
fprintf('---------------------------------------------\n');
fprintf('g-factor           : %.6f\n',Result.g);
fprintf('Hyperfine A (MHz)  : %.3f\n',Result.A);
fprintf('Line Width (mT)    : %.4f\n',Result.lwpp);
fprintf('Field Shift (mT)   : %.4f\n',Result.shift);
fprintf('Amplitude          : %.4f\n\n',Result.amplitude);

fprintf('Fit Quality\n');
fprintf('---------------------------------------------\n');
fprintf('Similarity         : %.2f %%\n',Result.Similarity);
fprintf('RMS Error          : %.6f\n',Result.RMS);
fprintf('R²                 : %.6f\n',Result.R2);

fprintf('\n=============================================\n');
fprintf('Fit completed successfully.\n');
fprintf('=============================================\n');
