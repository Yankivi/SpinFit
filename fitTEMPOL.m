function Result = fitTEMPOL(Exp,Sys)
% fitTEMPOL Backward-compatible TEMPOL fitting wrapper.

Radical = struct();
Radical.Name = string(Sys.Name);
Radical.ID = string(Sys.Name);
Radical.Sys = rmfield(Sys, intersect(fieldnames(Sys), {'Name','FieldShift','Amplitude'}));
Radical.Sim.Method = "garlic";
Radical.Fit.gLower = -0.003 * ones(size(Radical.Sys.g));
Radical.Fit.gUpper =  0.003 * ones(size(Radical.Sys.g));
Radical.Fit.ALower = -10 * ones(size(Radical.Sys.A));
Radical.Fit.AUpper =  10 * ones(size(Radical.Sys.A));
Radical.Fit.lwLower = 0.02;
Radical.Fit.lwUpper = 1.00;

Result = fitSpectrum(Exp,Radical);
end
