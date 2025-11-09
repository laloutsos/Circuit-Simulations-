1;
function SwitchingActivity = lab33montecarlo(N)
% LAB33MONTECARLO - Computes the switching activity of ALL circuit signals
% using Monte Carlo simulation.
%
% N = number of random input vectors (e.g. 1000)
%
% Requires: TopologicalCircuitMaker.m and circuit file 'myUnsortedCircuit1.txt'

%% --- Create workload (input vectors) ---
Workload = [
    0 0 0;
    1 1 1;
    0 0 1;
    1 1 0;
    0 1 0
];

% Add N random input vectors for Monte Carlo simulation
for i = 1:N
    Workload = [Workload; round(rand()), round(rand()), round(rand())];
end

vectorsNumber = size(Workload, 1);

%% --- Initialize signals and get circuit information ---
% Run once to obtain all signal names from the circuit
[SignalsTable, allSignals] = TopologicalCircuitMaker('myUnsortedCircuit1.txt', 1, 1, 0);

nSignals = length(allSignals);        % total number of signals in the circuit
SwitchCounters = zeros(1, nSignals);  % counter for how many times each signal switches

% Store previous signal values (initially from the first circuit run)
prevSignals = SignalsTable;

%% --- Monte Carlo simulation loop ---
for i = 1:vectorsNumber
    % Get the input vector for this iteration
    a = Workload(i,1);
    b = Workload(i,2);
    c = Workload(i,3);

    % Evaluate the circuit for these inputs
    [SignalsTable, allSignals] = TopologicalCircuitMaker('myUnsortedCircuit1.txt', a, b, c);

    % Compare current and previous signal values
    for s = 1:nSignals
        if SignalsTable(s) ~= prevSignals(s)
            SwitchCounters(s) = SwitchCounters(s) + 1;  % increment counter if value changed
        end
    end

    % Save current signals for the next comparison
    prevSignals = SignalsTable;
end

%% --- Compute switching activity for each signal ---
SwitchingActivity = SwitchCounters / vectorsNumber;

%% --- Display results ---
disp('----------------------------------------');
disp('Switching Activity per signal:');
for s = 1:nSignals
    fprintf('%-10s : %.4f\n', allSignals{s}, SwitchingActivity(s));
end

avgActivity = mean(SwitchingActivity);
disp('----------------------------------------');
fprintf('Average Circuit Switching Activity: %.4f\n', avgActivity);

end

