1;
function scores = evaluateRandomIndividuals(circuitFile, numIndividuals, numInputs, L)
% evaluateRandomIndividuals - Generates random individuals and evaluates their switch scores

scores = zeros(1, numIndividuals);

%% Retrieve TLPINPUTS from the circuit file
fid = fopen(circuitFile,'r');
firstLine = fgetl(fid);
fclose(fid);

if startsWith(strtrim(firstLine),'TLPINPUTS')
    tlpinputs = strsplit(strtrim(firstLine));
    tlpinputs = tlpinputs(2:end); % Exclude the 'TLPINPUTS' keyword itself
else
    tlpinputs = {};
end

%% Generate and evaluate individuals
for i = 1:numIndividuals
    % Generate a random workload of length L
    workload = randi([0,1], L, numInputs);

    % Apply the first vector
    [SignalsBefore, allSignals] = TopologicalCircuitMaker(circuitFile, num2cell(workload(1,:)){:});

    % Apply the second vector
    [Signals, ~] = TopologicalCircuitMaker(circuitFile, num2cell(workload(2,:)){:});

    % Find indices of primary inputs to exclude them from switch counting
    tlpIdx = [];
    for t = 1:length(tlpinputs)
        idx = find(strcmp(tlpinputs{t}, allSignals));
        if ~isempty(idx)
            tlpIdx = [tlpIdx, idx];
        end
    end

    % Count switches for non-primary inputs
    switches = sum(SignalsBefore(setdiff(1:length(SignalsBefore), tlpIdx)) ...
                   ~= Signals(setdiff(1:length(Signals), tlpIdx)));

    scores(i) = switches;
end

%% Compute mean and variance
averageSwitches = mean(scores);
varianceSwitches = var(scores);

%% Plot results
figure;
plot(1:numIndividuals, scores, 'b.-');
xlabel('Individual #');
ylabel('Score (number of switches)');
title('Scores of random individuals for the circuit');
grid on;

str = sprintf('Mean = %.2f\nVariance = %.2f', averageSwitches, varianceSwitches);
xLimits = xlim;
yLimits = ylim;
xPos = xLimits(2) - 0.05*(xLimits(2)-xLimits(1));
yPos = yLimits(2) - 0.05*(yLimits(2)-yLimits(1));
text(xPos, yPos, str, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', 'FontSize', 10, 'BackgroundColor', 'w', 'EdgeColor', 'k');

end

