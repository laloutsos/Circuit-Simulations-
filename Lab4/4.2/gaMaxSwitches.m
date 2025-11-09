1;
function [bestWorkload, bestScore, scoreG] = gaMaxSwitches(circuitFile, numGenerations, N, L, numInputs, crossoverRate, mutationRate)

fid = fopen(circuitFile,'r');
firstLine = fgetl(fid);
fclose(fid);
if startsWith(strtrim(firstLine),'TLPINPUTS')
    tlpinputs = strsplit(strtrim(firstLine));
    tlpinputs = tlpinputs(2:end); % skip the keyword itself
else
    tlpinputs = {};
end

population = cell(1, N);
for i = 1:N
    population{i} = randi([0, 1], L, numInputs);
end

scoreG = zeros(1, numGenerations);
bestScore = -inf;
bestWorkload = [];

for g = 1:numGenerations
    scores = zeros(1, N);

    for i = 1:N
        workload = population{i};

        % --- Evaluate first and second input vectors ---
        [SignalsBefore, allSignals] = TopologicalCircuitMaker(circuitFile, num2cell(workload(1,:)){:});
        [Signals, ~] = TopologicalCircuitMaker(circuitFile, num2cell(workload(2,:)){:});

        % --- Find indices of TLPINPUTS to ignore ---
        tlpIdx = [];
        for t = 1:length(tlpinputs)
            idx = find(strcmp(tlpinputs{t}, allSignals));
            if ~isempty(idx)
                tlpIdx = [tlpIdx, idx];
            end
        end

        % --- Compute number of switches excluding inputs ---
        switches = sum(SignalsBefore(setdiff(1:length(SignalsBefore), tlpIdx)) ...
                       ~= Signals(setdiff(1:length(Signals), tlpIdx)));

        scores(i) = switches;
    end

    % --- Record generation best ---
    [scoreG(g), idxBest] = max(scores);
    if scoreG(g) > bestScore
        bestScore = scoreG(g);
        bestWorkload = population{idxBest};
    end

    % --- Selection ---
    [parent1, parent2, ~, ~] = gaSelectParents(scores, population, N, L);

    % --- Create next generation ---
    newPopulation = cell(1, N);
    for i = 1:N
        % Crossover
        if rand < crossoverRate
            point = randi([1, L]);
            offspring = [parent1(1:point, :); parent2(point+1:end, :)];
        else
            offspring = parent1;
        end

        % Mutation
        for r = 1:L
            for c = 1:numInputs
                if rand < mutationRate
                    offspring(r, c) = 1 - offspring(r, c);
                end
            end
        end
        newPopulation{i} = offspring;
    end

    population = newPopulation;
    fprintf('Generation %d: max switches = %d\n', g, scoreG(g));
end
figure;
plot(1:numGenerations, scoreG, 'b.-', 'LineWidth', 1.5, 'MarkerSize', 10);
xlabel('Generation g');
ylabel('Max Score per Generation (switching activity)');
title('Evolution of GA for wtfcircuit.txt');
grid on;

disp('Best workload found:');
disp(bestWorkload);
disp(['Best switching activity: ', num2str(bestScore)]);


end

