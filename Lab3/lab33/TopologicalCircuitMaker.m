1;
function [SignalsTable, allSignals] = TopologicalCircuitMaker(circuitFile, varargin)
% CircuitMaker - Circuit simulator from file (Format 2)
% Usage:
%   [SignalsTable, allSignals] = CircuitMaker('circuit.txt', 1, 0, 1)
%
% Two input detection modes:
%   Mode A: first line in file "top_inputs a b c"
%   Mode B: automatic: any signal not written by any element

    fid = fopen(circuitFile,'r');
    if fid == -1
        error('File not found: %s', circuitFile);
    end

    ElementsTable = {};
    allSignals = {};
    outputs = {};
    primaryInputs = {};

    tline = fgetl(fid); % reads the first line

    % --- Check for top_inputs (Mode A) ---
    if ischar(tline) && startsWith(strtrim(tline), 'TLPINPUTS')
        tokens = strsplit(strtrim(tline));
        primaryInputs = tokens(2:end); % Mode A
        tline = fgetl(fid);            % next line
    end

    % --- Read the rest of the elements ---
    while ischar(tline)
        tline = strtrim(tline);
        if isempty(tline) || startsWith(tline,'#')
            tline = fgetl(fid); continue;
        end
        tokens = strsplit(tline);
        if numel(tokens) < 2
            tline = fgetl(fid); continue;
        end
        el.type = upper(tokens{1});
        el.output = tokens{2};
        if numel(tokens) > 2
            el.inputs = tokens(3:end);
        else
            el.inputs = {};
        end
        ElementsTable{end+1} = el;
        outputs{end+1} = el.output;
        allSignals = [allSignals, el.inputs, {el.output}];
        tline = fgetl(fid);
    end
    fclose(fid);

    allSignals = unique(allSignals, 'stable');

    % --- Mode B: detect inputs automatically if not top_inputs ---
    if isempty(primaryInputs)
        primaryInputs = setdiff(allSignals, outputs, 'stable');
    end

    % Check that correct number of inputs is given
    nInputs = length(primaryInputs);
    if length(varargin) ~= nInputs
        error('You must provide %d input values: %s', ...
               nInputs, strjoin(primaryInputs, ', '));
    end

    % --- Create SignalsTable ---
    SignalsTable = zeros(1, length(allSignals));
    for i = 1:nInputs
        idx = find(strcmp(allSignals, primaryInputs{i}));
        SignalsTable(idx) = varargin{i};
    end

    % --- Sort logic elements in correct processing order ---
    sortedElements = {}; % here sorted elements will be put
    remaining = ElementsTable; % Elements that have not been sorted yet

    while ~isempty(remaining)                   % Loop until all gates are sorted
        progress = false;                       % Flag to check if we made progress in this pass
        for i = 1:length(remaining)            % Iterate over all remaining gates
            el = remaining{i};                 % Get the current gate
            availableOutputs = [primaryInputs, cellfun(@(x)x.output, sortedElements, 'UniformOutput', false)];
                                                 % List of signals currently available
            if all(ismember(el.inputs, availableOutputs))
                sortedElements{end+1} = el;    % Add this gate to the sorted list
                remaining(i) = [];             % Remove it from remaining gates
                progress = true;               % Mark that we made progress
                break;                         % Restart the loop from the beginning
            end
        end
        if ~progress
            error('Cyclic dependency or undefined input detected in circuit.');
        end
    end

    ElementsTable = sortedElements;
    % --- Print sorted order of elements ---
    fprintf('Sorted processing order:\n');
    for i = 1:length(ElementsTable)
        el = ElementsTable{i};
        fprintf('%2d: %s -> %s (inputs: %s)\n', ...
            i, el.type, el.output, strjoin(el.inputs, ', '));
    end
    fprintf('\n');

    % --- Evaluate the circuit ---
    for i = 1:length(ElementsTable)
        el = ElementsTable{i};
        inVals = cell(1,length(el.inputs));
        for j = 1:length(el.inputs)
            idx = find(strcmp(allSignals, el.inputs{j}));
            inVals{j} = SignalsTable(idx);
        end
        % Compute output
        switch el.type
          case 'AND'
              outVal = spAND(inVals{:});
          case 'OR'
              outVal = spOR(inVals{:});
          case 'NOT'
              if isempty(inVals)
                  error('NOT gate requires input');
              end
              outVal = spNOT(inVals{1});
          case 'NAND'
              outVal = spNAND(inVals{:});
          case 'NOR'
              outVal = spNOR(inVals{:});
          case 'XOR'
              outVal = spXOR(inVals{:});
          case 'XNOR'
              outVal = spXNOR(inVals{:});
          otherwise
              error('Unknown gate type: %s', el.type);
        end
        % Store output
        outIdx = find(strcmp(allSignals, el.output));
        SignalsTable(outIdx) = outVal;
    end

    % --- Print results ---
    fprintf('Circuit results:\n');
    for i = 1:length(allSignals)
        fprintf('%s = %d\n', allSignals{i}, SignalsTable(i));
    end

end

