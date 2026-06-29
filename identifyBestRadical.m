function Result = identifyBestRadical(Exp,Library)
% identifyBestRadical Simulates every library radical and returns best match.

nRadicals = numel(Library);

if nRadicals == 0
    error('Library is empty.');
end

Results = struct([]);

fprintf('\nSearching radical library...\n');
fprintf('------------------------------------------\n');

for k = 1:nRadicals
    Sim = simulateRadical(Library(k),Exp);
    [rmsValue,r2Value,similarity] = similarityScore(Exp.Signal,Sim.Signal);

    Results(k).Index = k;
    Results(k).Name = Library(k).Name;
    Results(k).Score = similarity;
    Results(k).RMS = rmsValue;
    Results(k).R2 = r2Value;
    Results(k).Simulation = Sim;
    Results(k).Radical = Library(k);

    fprintf('%-20s %.2f %%\n',Library(k).Name,similarity);
end

fprintf('------------------------------------------\n');

scores = [Results.Score];
[~,idx] = max(scores);

Result = Results(idx);
Result.AllResults = Results;

fprintf('\nBest match : %s\n',Result.Name);
fprintf('Similarity : %.2f %%\n',Result.Score);

figure('Name','Library search');
plot(Exp.Field,Exp.Signal,'k','LineWidth',1.5);
hold on
plot(Result.Simulation.Field,Result.Simulation.Signal,'r','LineWidth',1.5);
grid on
box on
xlabel('Magnetic field (mT)')
ylabel('Normalized intensity')
title(sprintf('%s   (%.2f%%)',Result.Name,Result.Score));
legend('Experimental','Simulated','Location','best');

end
