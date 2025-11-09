1;
function SwitchingActivity = lab32montecarlo(N)
%% LAB32MONTECARLO - Monte Carlo switching activity for all signals

%% --- Initialize workload with typical examples ---
Workload = [
    0 0 0;
    1 1 1;
    0 0 1;
    1 1 0;
    0 1 0
];

%% Add N random input vectors for Monte Carlo simulation
for i = 1:N
    Workload = [Workload; round(rand()), round(rand()), round(rand())];
end

vectorsNumber = size(Workload, 1);

%% --- Get signal names from circuit (once) ---
% Use first workload vector to initialize signals
initialSignals = myCircuit1(Workload(1,1), Workload(1,2), Workload(1,3));
nSignals = length(initialSignals);

% Initialize previous signals using first workload vector
prevSignals = initialSignals;

% Initialize counters for signal switches
SwitchCounters = zeros(1, nSignals);

%% --- Monte Carlo simulation loop ---
for i = 1:vectorsNumber
    a = Workload(i,1);
    b = Workload(i,2);
    c = Workload(i,3);

    % Evaluate the circuit for current inputs
    currentSignals = myCircuit1(a,b,c);

    % Compare current and previous signal values
    for s = 1:nSignals
        if currentSignals(s) ~= prevSignals(s)
            SwitchCounters(s) = SwitchCounters(s) + 1; % increment switch counter
        end
    end

    % Save current signals for next comparison
    prevSignals = currentSignals;
end

%% --- Compute switching activity for each signal ---
SwitchingActivity = SwitchCounters / vectorsNumber;

%% --- Display results ---
disp('----------------------------------------');
disp('Switching Activity per signal:');
signalNames = {'a', 'b', 'c', 'f', 'e', 'd'};  % mapping of indices to signal names

for s = 1:nSignals
    fprintf('Signal %-2s : %.4f\n', signalNames{s}, SwitchingActivity(s));
end

avgActivity = mean(SwitchingActivity);
disp('----------------------------------------');
fprintf('Average Circuit Switching Activity: %.4f\n', avgActivity);

end

