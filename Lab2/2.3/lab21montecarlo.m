1;
function SwitchingActivity = lab21montecarlo(N)
%% N Monte Carlo permutations to be performed for lab21(a,b,c)

%% Initialize the workload with some typical examples
Workload = [
    0 0 0;
    1 1 1;
    0 0 1;
    1 1 0;
    0 1 0
];

%% Add random input vectors for Monte Carlo simulation
for i = 1:N
    Workload = [Workload; round(rand()), round(rand()), round(rand())];
end

vectorsNumber = size(Workload, 1);

%% Initialize previous output of the lab21 function
prevOutput = lab21(0,0,0);  % prevOutput will be a vector [e,f,d]

switchesNumber = zeros(1,3); % Counter for switches of e,f,d separately

%% Loop over all input vectors and count output switches
for i = 1:vectorsNumber
    a = Workload(i,1);
    b = Workload(i,2);
    c = Workload(i,3);

    newOutput = lab21(a,b,c);  % [e,f,d]

    %% If output changed, increment switches counter for each element
    for j = 1:3
        if newOutput(j) ~= prevOutput(j)
            switchesNumber(j) = switchesNumber(j) + 1;
        end
    end

    prevOutput = newOutput;  % Update previous output
end

%% Compute switching activity for each output
SwitchingActivity = switchesNumber / vectorsNumber;

%% Display results
disp(['Vectors: ', num2str(vectorsNumber)]);
disp(['Switches (e, f, d): ', num2str(switchesNumber)]);
disp(['Switching Activity (e, f, d): ', num2str(SwitchingActivity)]);

end

