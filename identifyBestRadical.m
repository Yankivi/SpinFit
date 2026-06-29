function Result = identifyBestRadical(Exp,Library)
%==============================================================
% identifyBestRadical
%
% Compares experimental spectrum with every radical
% from the library and returns the best candidate.
%
% INPUT
%   Exp
%   Library
%
% OUTPUT
%   Result
%
%==============================================================

nRadicals = numel(Library);

if nRadicals==0
    error('Library is empty.');
end

Results = struct([]);

fprintf('\n');
fprintf('Searching radical library...\n');
fprintf('------------------------------------------\n');

for k = 1:nRadicals

    Sim = simulateRadical(Library(k),Exp);

    score = similarityScore(Exp.Signal,Sim.Signal);

    Results(k).Index = k;
    Results(k).Name = Library(k).Name;
    Results(k).Score = score;
    Results(k).Simulation = Sim;
    Results(k).Radical = Library(k);

    fprintf('%-20s %.2f %%\n',Library(k).Name,score*100);

end

fprintf('------------------------------------------\n');

scores = [Results.Score];

[~,idx] = max(scores);

Result = Results(idx);

Result.AllResults = Results;

fprintf('\n');
fprintf('Best match : %s\n',Result.Name);
fprintf('Similarity : %.2f %%\n',Result.Score*100);

%% -------------------------------------------------------------
% Plot comparison
%% -------------------------------------------------------------

figure('Name','Library search');

plot(Exp.Field,Exp.Signal,...
    'k','LineWidth',1.5);

hold on

plot(Result.Simulation.Field,...
     Result.Simulation.Signal,...
     'r','LineWidth',1.5);

grid on
box on

xlabel('Magnetic field (mT)')
ylabel('Normalized intensity')

title(sprintf('%s   (%.2f%%)',...
    Result.Name,...
    Result.Score*100));

legend('Experimental','Simulated',...
    'Location','best');

end
