function [B, Signal] = simulateSpectrum(Sys, Exp)
% simulateSpectrum Simulates and normalizes an EasySpin spectrum on Exp axis.

Radical = struct();
Radical.Name = Sys.Name;
Radical.Sys = rmfield(Sys, intersect(fieldnames(Sys), {'Name','FieldShift','Amplitude'}));
Radical.Sim.Method = "garlic";
Radical.Sim.RangeMargin = 2;

Sim = simulateRadical(Radical, Exp);
B = Sim.Field;
Signal = Sim.Signal;

end
