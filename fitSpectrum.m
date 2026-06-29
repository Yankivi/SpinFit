function Result = fitSpectrum(Exp,Radical)
% fitSpectrum Fits a selected library radical to an experimental spectrum.

x0 = [Radical.Sys.g(:).' Radical.Sys.A(:).' Radical.Sys.lwpp 0 1];
ng = numel(Radical.Sys.g);
nA = numel(Radical.Sys.A);

lb = [Radical.Sys.g(:).' + Radical.Fit.gLower(:).' ...
      Radical.Sys.A(:).' + Radical.Fit.ALower(:).' ...
      Radical.Fit.lwLower -0.5 0.2];
ub = [Radical.Sys.g(:).' + Radical.Fit.gUpper(:).' ...
      Radical.Sys.A(:).' + Radical.Fit.AUpper(:).' ...
      Radical.Fit.lwUpper 0.5 3.0];

model = @(p) simulateRadicalForFit(p,Exp,Radical,ng,nA);

if exist('lsqcurvefit','file') == 2
    options = optimoptions('lsqcurvefit', ...
        'Display','iter', ...
        'Algorithm','trust-region-reflective', ...
        'MaxIterations',200, ...
        'MaxFunctionEvaluations',5000);

    best = lsqcurvefit(@(p,~) model(p),x0,Exp.Field,Exp.Signal,lb,ub,options);
else
    warning('lsqcurvefit is unavailable. Falling back to fminsearch with bound penalties.');
    objective = @(p) sum((model(applyBounds(p,lb,ub)) - Exp.Signal).^2);
    best = applyBounds(fminsearch(objective,x0),lb,ub);
end

Calc = model(best);
[RMS,R2,Similarity] = similarityScore(Exp.Signal,Calc);

Result = struct();
Result.Name = Radical.Name;
Result.Radical = Radical;
[~,~,Result.InitialSimilarity] = similarityScore(Exp.Signal,simulateRadical(Radical,Exp).Signal);
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

function Signal = simulateRadicalForFit(p,Exp,Radical,ng,nA)
Radical.Sys.g = p(1:ng);
Radical.Sys.A = p(ng+1:ng+nA);
Radical.Sys.lwpp = p(ng+nA+1);
fieldShift = p(ng+nA+2);
amplitude = p(ng+nA+3);

Sim = simulateRadical(Radical,Exp);
Signal = interp1(Sim.Field + fieldShift,Sim.Signal,Exp.Field,'linear',0);
Signal = normalizeSignal(Signal .* amplitude);
end

function p = applyBounds(p,lb,ub)
p = max(lb,min(ub,p));
end
