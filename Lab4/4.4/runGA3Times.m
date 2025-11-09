1;
function [scoreG_all, bestWorkloads, bestScores] = runGA3Times(circuitFile, numGenerations, N, L, numInputs, crossoverRate, mutationRate)
% runGA3Times - Executes the GA three times on a given circuit file
%
% Inputs:
%   circuitFile    - path to the circuit text file
%   numGenerations - number of generations
%   N              - population size
%   L              - workload length
%   numInputs      - number of primary inputs
%   crossoverRate  - probability of performing crossover (0 to 1)
%   mutationRate   - probability of mutation per bit (0 to 1)
%
% Outputs:
%   scoreG_all     - 3 x numGenerations array of max scores per generation
%   bestWorkloads  - cell array with best workload per run
%   bestScores     - array with best switching activity per run

% --- Prepare storage for results ---
scoreG_all = zeros(3, numGenerations);
bestWorkloads = cell(1,3);
bestScores = zeros(1,3);

% --- Colors for plotting ---
colors = {'b.-','r.-','g.-'};

% --- Run GA 3 times ---
figure; hold on;  % prepare figure for plotting

for run = 1:3
    fprintf('Execution #%d\n', run);

    % Call GA function
    [bestWorkload, bestScore, scoreG] = gaMaxSwitches(circuitFile, numGenerations, ...
                                                       N, L, numInputs, ...
                                                       crossoverRate, mutationRate);

    % Store results
    scoreG_all(run,:) = scoreG;
    bestWorkloads{run} = bestWorkload;
    bestScores(run) = bestScore;

    % Plot the max score per generation for this run
    plot(1:numGenerations, scoreG, colors{run}, 'LineWidth', 1.5, 'MarkerSize', 10);
end

% --- Finalize plot ---
xlabel('Generation g');
ylabel('Max Score per Generation (switching activity)');
title('Evolution of GA for circuit file');
grid on;
legend('Run 1','Run 2','Run 3');

% --- Display best workloads and their scores ---
for run = 1:3
    fprintf('\n--- Run %d ---\n', run);
    fprintf('Best workload (input vectors for L=%d):\n', L);
    disp(bestWorkloads{run});
    fprintf('Best switching activity: %d\n', bestScores(run));
end

end

