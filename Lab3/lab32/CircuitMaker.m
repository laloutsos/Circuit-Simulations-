1;
function SignalsTable = CircuitMaker(circuitFile, varargin)
% CircuitMaker - Circuit simulator from file (Format 2)
% Usage:
%   CircuitMaker('circuit.txt', 1, 0, 1)
%
% Two input detection modes:
%   Mode A: first line in file "top_inputs a b c"
%   Mode B: automatic: any signal not writtens by any element

    fid = fopen(circuitFile,'r');
    if fid == -1
        error('File not found: %s', scircuitFile);
    end

    ElementsTable = {};
    allSignals = {};
    outputs = {};
    primaryInputs = {};

    tline = fgetl(fid); % reads the first line

    % --- Check for top_inputs (Mode A) ---
    if ischar(tline) && startsWith(strtrim(tline), 'top_inputs')
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

    % --- Evaluate the circuit ---
    for i = 1:length(ElementsTable)
        % Loop through each element in the ElementsTable

        el = ElementsTable{i};
        % Get the current element structure (contains inputs, outputs, etc.)

        inVals = cell(1, length(el.inputs));
        % Create a cell array to store the input values for this element

        for j = 1:length(el.inputs)
            % Loop through each input of the current element

            idx = find(strcmp(allSignals, el.inputs{j}));
            % Find the index of this input signal in the list of all signals

            inVals{j} = SignalsTable(idx);
            % Retrieve the corresponding signal value from SignalsTable
            % and store it in the inVals list
        end
        % Compute output
    switch el.type
      case 'AND'
          outVal = spAND(inVals{:});        % n-input AND
      case 'OR'
          outVal = spOR(inVals{:});         % n-input OR
      case 'NOT'
          if isempty(inVals)
              error('NOT gate requires input');
          end
          outVal = spNOT(inVals{1});        %  1 input
      case 'NAND'
          outVal = spNAND(inVals{:});       % n-input NAND
      case 'NOR'
          outVal = spNOR(inVals{:});        % n-input NOR
      case 'XOR'
          outVal = spXOR(inVals{:});        % n-input XOR
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

