function [B,Signal] = simulateSpectrum(Sys,Exp)
%==========================================================
% Simulate spectrum using EasySpin
%==========================================================

Radical = struct();

Radical.Name = Sys.Name;

Radical.Sys = rmfield(Sys, ...
    intersect(fieldnames(Sys),{'Name','FieldShift','Amplitude'}));

Radical.Sim.Method = "garlic";

Radical.Sim.RangeMargin = 2;

Sim = simulateRadical(Radical,Exp);

%% Используем исходный спектр EasySpin

B = Sim.RawField;

Signal = Sim.RawSignal;

end


