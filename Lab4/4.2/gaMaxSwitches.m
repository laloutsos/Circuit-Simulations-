1;
function [bestWorkload, bestScore, scoreG] = gaMaxSwitches(circuitFile, numGenerations, N, L, numInputs, crossoverRate, mutationRate)
% gaMaxSwitches - Genetic Algorithm to maximize switching activity of a circuit
%
% Inputs:
%   circuitFile    - text file describing the circuit (first line: TLPINPUTS ...)
%   numGenerations - number of generations for the GA
%   N              - population size (number of workloads per generation)
%   L              - number of time steps in each workload
%   numInputs      - number of primary inputs of the circuit
%   crossoverRate  - probability of crossover
%   mutationRate   - probability of mutation per bit
%
% Outputs:
%   bestWorkload   - workload with maximum switches found
%   bestScore      - maximum number of switches
%   scoreG         - max switches per generation

%% --- Read TLPINPUTS from circuit file ---
fid = fopen(circuitFile,'r');
firstLine = fgetl(fid);
fclose(fid);

if startsWith(strtrim(firstLine),'TLPINPUTS')
    tlpinputs = strsplit(strtrim(firstLine));
    tlpinputs = tlpinputs(2:end); % skip the keyword itself
else
    tlpinputs = {};
end

%% --- Initialize population ---
population = cell(1, N);
for i = 1:N
    population{i} = randi([0, 1], L, numInputs);
end

%% --- GA variables ---
scoreG = zeros(1, numGenerations);
bestScore = -inf;
bestWorkload = [];

%% --- GA main loop ---
for g = 1:numGenerations
    scores = zeros(1, N);

    for i = 1:N
        workload = population{i};
        switches = 0;  % total switches for this workload

        % Evaluate switches across all consecutive time steps
        for k = 1:(L-1)
            [SignalsBefore, allSignals] = TopologicalCircuitMaker(circuitFile, num2cell(workload(k,:)){:});
            [Signals, ~] = TopologicalCircuitMaker(circuitFile, num2cell(workload(k+1,:)){:});

            % Identify indices of primary inputs
            tlpIdx = [];
            for t = 1:length(tlpinputs)
                idx = find(strcmp(tlpinputs{t}, allSignals));
                if ~isempty(idx)
                    tlpIdx = [tlpIdx, idx];
                end
            end

            % Count switches excluding primary inputs
            nonInputIdx = setdiff(1:length(Signals), tlpIdx);
            switches = switches + sum(SignalsBefore(nonInputIdx) ~= Signals(nonInputIdx));
        end

        scores(i) = switches;
    end

    %% --- Record best of this generation ---
    [scoreG(g), idxBest] = max(scores);
    if scoreG(g) > bestScore
        bestScore = scoreG(g);
        bestWorkload = population{idxBest};
    end

    %% --- Selection ---
    [parent1, parent2, ~, ~] = gaSelectParents(scores, population, N, L);

    %% --- Create next generation ---
    newPopulation = cell(1, N);
    newPopulation{1} = parent1;
    newPopulation{2} = parent2;

    for i = 3:N
        % Crossover
        if rand < crossoverRate
            point = randi([1, L]);
            if rand < 0.5
                offspring = [parent1(1:point, :); parent2(point+1:end, :)];
            else
                offspring = [parent2(1:point, :); parent1(point+1:end, :)];
            end
            %offspring = [parent1(1:point, :); parent2(point+1:end, :)];
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

%% --- Output best solution ---
disp('Best workload found:');
disp(bestWorkload);
disp(['Best switching activity: ', num2str(bestScore)]);

end

