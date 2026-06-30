function Result = fitSpectrum(Exp,Radical)
% fitSpectrum Fits a selected library radical to an experimental spectrum.
%
% The optimizer vector is built explicitly so it always contains:
%   [g values, A values, lwpp, field shift, amplitude]
% even if a library entry has an empty lwpp or incomplete fit bounds.

[g0,gLower,gUpper] = buildFitVector(Radical.Sys.g,Radical.Fit.gLower,Radical.Fit.gUpper,0.003);
[A0,ALower,AUpper] = buildFitVector(Radical.Sys.A,Radical.Fit.ALower,Radical.Fit.AUpper,10);
lw0 = scalarOrDefault(Radical.Sys,'lwpp',0.18);
lwLower = scalarOrDefault(Radical.Fit,'lwLower',0.02);
lwUpper = scalarOrDefault(Radical.Fit,'lwUpper',1.00);

x0 = [g0 A0 lw0 0 1];
lb = [gLower ALower lwLower -0.5 0.05];
ub = [gUpper AUpper lwUpper 0.5 5.00];

ng = numel(g0);
nA = numel(A0);
expectedN = ng + nA + 3;

if numel(x0) ~= expectedN || numel(lb) ~= expectedN || numel(ub) ~= expectedN
    error('Internal fitting vector size mismatch: x0=%d, lb=%d, ub=%d, expected=%d.', ...
        numel(x0),numel(lb),numel(ub),expectedN);
end

model = @(p) simulateForFit(p,Exp,Radical,ng,nA,expectedN);

if exist('lsqcurvefit','file') == 2
    options = optimoptions('lsqcurvefit', ...
        'Display','iter', ...
        'Algorithm','trust-region-reflective', ...
        'MaxIterations',200, ...
        'MaxFunctionEvaluations',5000);

    best = lsqcurvefit(@(p,~) model(p),x0,Exp.Field,Exp.Signal,lb,ub,options);
else
    warning('lsqcurvefit is unavailable. Falling back to fminsearch with bound clipping.');
    objective = @(p) sum((model(applyBounds(p,lb,ub)) - Exp.Signal).^2);
    best = applyBounds(fminsearch(objective,x0),lb,ub);
end

Calc = model(best);
[RMS,R2,Similarity] = similarityScore(Exp.Signal,Calc);
[~,~,InitialSimilarity] = similarityScore(Exp.Signal,simulateRadical(Radical,Exp).Signal);

Result = struct();
Result.Name = Radical.Name;
Result.Radical = Radical;
Result.InitialSimilarity = InitialSimilarity;
Result.g = best(1:ng);
Result.A = best(ng+1:ng+nA);
Result.lwpp = best(ng+nA+1);
Result.shift = best(ng+nA+2);
Result.amplitude = best(ng+nA+3);
Result.FieldShift = Result.shift;
Result.Amplitude = Result.amplitude;
Result.B = Exp.Field;
Result.Field = Exp.Field;
Result.Signal = Calc;
Result.RMS = RMS;
Result.R2 = R2;
Result.Similarity = Similarity;
Result.Parameters = table({Result.g},{Result.A},Result.lwpp,Result.shift,Result.amplitude, ...
    'VariableNames',{'g','A_MHz','lwpp','FieldShift','Amplitude'});
end
