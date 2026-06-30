function Match = identifyBestRadical(Exp,Library)
%==============================================================
% identifyBestRadical
%
% Finds the radical from the library that best matches
% the experimental spectrum.
%==============================================================

fprintf('\n');
fprintf('Searching radical library...\n');
fprintf('------------------------------------------\n');

n = numel(Library);

Scores = zeros(n,1);

for k = 1:n

    %% Simulate

    Sim = simulateRadical(Library(k),Exp);

    %% Compare

    [~,~,Scores(k)] = similarityScore( ...
        Exp.Signal,...
        Sim.Signal);

    fprintf('%-20s %8.2f %%\n', ...
        char(Library(k).Name), ...
        Scores(k));

end

%% Best match

[BestScore,idx] = max(Scores);

fprintf('------------------------------------------\n');

fprintf('Best match : %s\n',char(Library(idx).Name));

fprintf('Similarity : %.2f %%\n',BestScore);

fprintf('\n');

Match = struct();

Match.Index = idx;

Match.Score = BestScore;

Match.Radical = Library(idx);

Match.AllScores = Scores;

end
