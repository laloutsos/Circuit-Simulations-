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
% find primary inputs so that you can exclude them later
if startsWith(strtrim(firstLine),'TLPINPUTS')
    tlpinputs = strsplit(strtrim(firstLine));
    tlpinputs = tlpinputs(2:end); % skip the keyword itself
else
    tlpinputs = {};
end

%% --- (1.0)Initialize population ---
population = cell(1, N);
for i = 1:N
    population{i} = randi([0, 1], L, numInputs);
end

%% --- (1.1) GA variables ---
scoreG = zeros(1, numGenerations);
bestScore = -inf;
bestWorkload = [];

%% --- (2) Loop for every generation. GA main loop ---
for g = 1:numGenerations
    scores = zeros(1, N); % Here will be stored the score of every individual
    % Loop for every individual workload
    for i = 1:N
        workload = population{i};
        switches = 0;  % total switches for this workload

        % Evaluate switches across all consecutive time steps - (2.1) Length L of time series, t1,t2 etc
        for k = 1:(L-1)
            [SignalsBefore, allSignals] = TopologicalCircuitMaker(circuitFile, num2cell(workload(k,:)){:});
            [Signals, ~] = TopologicalCircuitMaker(circuitFile, num2cell(workload(k+1,:)){:});

            % (2.2) Identify indices of primary inputs
            tlpIdx = [];
            for t = 1:length(tlpinputs)
                idx = find(strcmp(tlpinputs{t}, allSignals));
                if ~isempty(idx)
                    tlpIdx = [tlpIdx, idx];
                end
            end

            % (2.3) Count switches excluding primary inputs
            nonInputIdx = setdiff(1:length(Signals), tlpIdx);
            switches = switches + sum(SignalsBefore(nonInputIdx) ~= Signals(nonInputIdx));
        end
        % Store the score of this individual
        scores(i) = switches;
    end

    %% --- We Record the best workload of this generation ---
    [scoreG(g), idxBest] = max(scores);
    if scoreG(g) > bestScore
        bestScore = scoreG(g);
        bestWorkload = population{idxBest};
    end

    %% --- Selection --- (3) We select the 2 individuals with the two best scores.
    [parent1, parent2, ~, ~] = gaSelectParents(scores, population, N, L);

    %% --- Create next generation ---
    newPopulation = cell(1, N);
    % (3.1 )Before we start crossover, we always store in the new population the two parents.
    newPopulation{1} = parent1;
    newPopulation{2} = parent2;
    % (4) We start doing crossoverfor the remaining inputs
    for i = 3:N
        % Crossover - crossoverRate always equals to 1 in our case
        if rand < crossoverRate
            % (4.1) We randomly define how many rows of the first and the second parent we will get
            point = randi([1, L]);
            % (4.2) With probability 50% we define who the first parent will be
            if rand < 0.5
                % our new individual!!
                offspring = [parent1(1:point, :); parent2(point+1:end, :)];
            else
                % our new individual!!
                offspring = [parent2(1:point, :); parent1(point+1:end, :)];
            end
            %offspring = [parent1(1:point, :); parent2(point+1:end, :)];
        else
            % our new individual!!
            offspring = parent1;
        end

        % (5) Mutation
        % We process seperately every bit of the new individual and with
        % probability m we reverse it
        for r = 1:L
            for c = 1:numInputs
                if rand < mutationRate
                    offspring(r, c) = 1 - offspring(r, c);
                end
            end
        end

        % (6) we store our new individual
        newPopulation{i} = offspring;
    end
    % (7) We redifine population equal to newPopulation and we start all over again for the next generation.
    population = newPopulation;

    fprintf('Generation %d: max switches = %d\n', g, scoreG(g));
end

%% --- Output best solution ---
disp('Best workload found:');
disp(bestWorkload);
disp(['Best switching activity: ', num2str(bestScore)]);

end

