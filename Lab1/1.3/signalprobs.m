%%%
%%%
%%% τρέχετε το πρόγραμμα ως:
%%% signalprobs(input1sp,input2sp)
%%%
%%% Παραδείγματα:
%%% >> signalprobs(0.5,0.5)
%%% AND Gate for input probabilities (0.500000 0.500000):
%%% ans =  0.25000
%%% OR Gate for input probabilities (0.500000 0.500000):
%%% ans =  0.75000
%%% XOR Gate for input probabilities (0.500000 0.500000):
%%% NAND Gate for input probabilities (0.500000 0.500000):
%%% NOR Gate for input probabilities (0.500000 0.500000):
%%%
%%%
%%% >> signalprobs(0,0)
%%% AND Gate for input probabilities (0.00000 0.00000):
%%% ans =  0
%%% OR Gate for input probabilities (0.00000 0.00000):
%%% ans =  0
%%% XOR Gate for input probabilities (0.00000 0.00000):
%%% NAND Gate for input probabilities (0.00000 0.00000):
%%% NOR Gate for input probabilities (0.00000 0.00000):
%%%
%%% >> signalprobs(1,1)
%%% AND Gate for input probabilities (1.00000 1.00000):
%%% ans =  1
%%% OR Gate for input probabilities (1.00000 1.00000):
%%% ans =  1
%%% XOR Gate for input probabilities (1.00000 1.00000):
%%% NAND Gate for input probabilities (1.00000 1.00000):
%%% NOR Gate for input probabilities (1.00000 1.00000):
%%%
%%%
%%%
%%% Οι συναρτήσεις που υπολογίζουν τα signal probabilities
%%% AND και OR πυλών δύο εισόδων έχουν ήδη υλοποιηθεί παρακάτω.
%%% Οι συναρτήσεις που υπολογίζουν τα signal probabilities
%%% XOR, NAND και NOR πυλών δύο εισόδων είναι ημιτελής.
%%% (α) Σας ζητείτε να συμπληρώσετε τις υπόλοιπες ημιτελής συναρτήσεις για τον υπολογισμό
%%% των signal probabilities XOR,NAND και NOR 2 εισόδων πυλών.
%%% (β) γράψτε συναρτήσεις για τον υπολογισμό των signal probabilities
%%% AND, OR, XOR, NAND, NOR πυλών 3 εισόδων
%%% (γ) γράψτε συναρτήσεις για τον υπολογισμό των signal probabilities
%%% AND, OR, XOR, NAND, NOR πυλών Ν εισόδων
1;
function s = signalprobs(input1sp, input2sp, input3sp, input4sp, input5sp)


  fprintf('\n==================== 2-INPUT GATES ====================\n');
  sp2AND(input1sp, input2sp)
  sp2OR(input1sp, input2sp)
  sp2XOR(input1sp, input2sp)
  sp2NAND(input1sp, input2sp)
  sp2NOR(input1sp, input2sp)

  fprintf('\n==================== 3-INPUT GATES ====================\n');
  sp3AND(input1sp, input2sp, input3sp)
  sp3OR(input1sp, input2sp, input3sp)
  sp3XOR(input1sp, input2sp, input3sp)
  sp3NAND(input1sp, input2sp, input3sp)
  sp3NOR(input1sp, input2sp, input3sp)

  fprintf('\n==================== N-INPUT GATES (5 INPUTS) ====================\n');
  spAND(input1sp, input2sp, input3sp, input4sp, input5sp)
  spOR(input1sp, input2sp, input3sp, input4sp, input5sp)
  spXOR(input1sp, input2sp, input3sp, input4sp, input5sp)
  spNAND(input1sp, input2sp, input3sp, input4sp, input5sp)
  spNOR(input1sp, input2sp, input3sp, input4sp, input5sp)

  fprintf('\n==================== 1-INPUT (NOT) GATE ====================\n');
  spNOT(input1sp)

  fprintf('\n==================== N-INPUT (XNOR) GATE ====================\n');
  spXNOR(input1sp, input2sp, input3sp, input4sp, input5sp)


  s = [];
endfunction

%

% 2-input AND gate truth table
% 0 0:0
% 0 1:0
% 1 0:0
% 1 1:1
%% signal probability calculator for a 2-input AND gate
%% input1sp: signal probability of first input signal
%% input2sp: signal probability of second input signal
%%        s: output signal probability
function s=sp2AND(input1sp, input2sp)
  %printf("AND Gate for input probabilities (%f %f):\n",input1sp,input2sp)
  s = input1sp*input2sp;
endfunction

function Esw = sw2AND(input1sp, input2sp)
  % Compute 2-input AND probability
  Pout = sp2AND(input1sp, input2sp);

  % Compute switching activity
  Esw = 2 * Pout * (1 - Pout);

  % Display results
  fprintf('Switching activity for 2-input AND gate:\n');
  fprintf('Inputs: %.4f, %.4f\n', input1sp, input2sp);
  fprintf('Esw = %.4f\n', Esw);
endfunction


function s=sp3AND(input1sp, input2sp, input3sp)
  printf("AND Gate for input probabilities (%f %f %f):\n",input1sp,input2sp,input3sp)
  s = input1sp*input2sp*input3sp;
endfunction

function Esw = sw3AND(input1sp, input2sp, input3sp)
  % Compute 3-input AND probability
  Pout = sp3AND(input1sp, input2sp, input3sp);

  % Compute switching activity
  Esw = 2 * Pout * (1 - Pout);

  % Display results
  fprintf('Switching activity for 3-input AND gate:\n');
  fprintf('Inputs: %.4f, %.4f, %.4f\n', input1sp, input2sp, input3sp);
  fprintf('Esw = %.4f\n', Esw);
endfunction


function s = spAND(varargin)

  % Convert input arguments to numeric vector
  p = cell2mat(varargin);

  % Display input probabilities
  %fprintf('AND Gate for input probabilities:\n');
  %disp(p);

  % AND probability = product of all input probabilities
  s = prod(p);
endfunction

function Esw = swAND(varargin)
  % Compute N-input AND probability
  Pout = spAND(varargin{:});  % pass all inputs to spAND

  % Compute switching activity
  Esw = 2 * Pout * (1 - Pout);

  % Display results
  fprintf('Switching activity for N-input AND gate:\n');
  disp(cell2mat(varargin));
  fprintf('Esw = %.4f\n', Esw);
endfunction




% 2-input OR gate truth table
% 0 0:0
% 0 1:1
% 1 0:1
% 1 1:1
%% signal probability calculator for a 2-input OR gate
%% input1sp: signal probability of first input signal
%% input2sp: signal probability of second input signal
%%        s: output signal probability
function s=sp2OR(input1sp, input2sp)
  printf("OR Gate for input probabilities (%f %f):\n",input1sp,input2sp)
  s = 1-(1-input1sp)*(1-input2sp);
endfunction

function Esw = sw2OR(input1sp, input2sp)
  % Compute 2-input OR probability
  Pout = sp2OR(input1sp, input2sp);

  % Compute switching activity
  Esw = 2 * Pout * (1 - Pout);

  % Display results
  fprintf('Switching activity for 2-input OR gate:\n');
  fprintf('Inputs: %.4f, %.4f\n', input1sp, input2sp);
  fprintf('Esw = %.4f\n', Esw);
endfunction


function s=sp3OR(input1sp, input2sp, input3sp)
  printf("OR Gate for input probabilities (%f %f %f):\n",input1sp,input2sp,input3sp)
  s = 1-(1-input1sp)*(1-input2sp)*(1-input3sp);
endfunction

function Esw = sw3OR(input1sp, input2sp, input3sp)
  % Compute 3-input OR probability
  Pout = sp3OR(input1sp, input2sp, input3sp);

  % Compute switching activity
  Esw = 2 * Pout * (1 - Pout);

  % Display results
  fprintf('Switching activity for 3-input OR gate:\n');
  fprintf('Inputs: %.4f, %.4f, %.4f\n', input1sp, input2sp, input3sp);
  fprintf('Esw = %.4f\n', Esw);
endfunction


function s = spOR(varargin)

  % Compute NOR probability first
  pNOR = spNOR(varargin{:});  % call spNOR with all inputs

  % OR probability = 1 - NOR probability
  s = 1 - pNOR;

  % Display result
  %fprintf('OR Gate for input probabilities:\n');
  %disp(cell2mat(varargin));
  %fprintf('Result: %.4f\n', s);
endfunction

function Esw = swOR(varargin)
  % Compute N-input OR probability
  Pout = spOR(varargin{:});  % call the general spOR

  % Compute switching activity
  Esw = 2 * Pout * (1 - Pout);

  % Display results
  fprintf('Switching activity for N-input OR gate:\n');
  disp(cell2mat(varargin));
  fprintf('Esw = %.4f\n', Esw);
endfunction




% 2-input XOR gate truth table
% 0 0:0
% 0 1:1
% 1 0:1
% 1 1:0
%% signal probability calculator for a 2-input XOR gate
%% input1sp: signal probability of first input signal
%% input2sp: signal probability of second input signal
%%        s: output signal probability
function s=sp2XOR(input1sp, input2sp)
  printf("XOR Gate for input probabilities (%f %f):\n",input1sp,input2sp)
  s = input1sp*(1-input2sp)+input2sp*(1-input1sp);
endfunction

function Esw = sw2XOR(input1sp, input2sp)
  % Compute 2-input XOR probability
  Pout = sp2XOR(input1sp, input2sp);

  % Compute switching activity
  Esw = 2 * Pout * (1 - Pout);

  % Display results
  fprintf('Switching activity for 2-input XOR gate:\n');
  fprintf('Inputs: %.4f, %.4f\n', input1sp, input2sp);
  fprintf('Esw = %.4f\n', Esw);
endfunction


function s=sp3XOR(input1sp, input2sp, input3sp)
  printf("XOR Gate for input probabilities (%f %f %f):\n",input1sp,input2sp,input3sp)
  s = input1sp*input2sp*input3sp+ input1sp*(1 - input2sp)*(1 - input3sp) + input2sp*(1 - input1sp)*(1 - input3sp) + input3sp*(1 - input1sp)*(1 - input2sp);
endfunction

function Esw = sw3XOR(input1sp, input2sp, input3sp)
  % Compute 3-input XOR probability
  Pout = sp3XOR(input1sp, input2sp, input3sp);

  % Compute switching activity
  Esw = 2 * Pout * (1 - Pout);

  % Display results
  fprintf('Switching activity for 3-input XOR gate:\n');
  fprintf('Inputs: %.4f, %.4f, %.4f\n', input1sp, input2sp, input3sp);
  fprintf('Esw = %.4f\n', Esw);
endfunction


function s = spXOR(varargin)
  % Count the number of inputs provided
  n = length(varargin);

  % Print the number of inputs
  printf("XOR Gate for %d input probabilities:\n", n);

  % Convert the cell array of inputs to a numeric vector and display it
  disp(cell2mat(varargin));

  % Convert the variable input arguments to a numeric vector for calculations
  p = cell2mat(varargin);

  % Compute the signal probability for N-input XOR using the general formula:
  % P(Y=1) = 0.5 * (1 - product(1 - 2*p_i))
  s = 0.5 * (1 - prod(1 - 2 .* p));
endfunction

function Esw = swXOR(varargin)
  % Compute N-input XOR probability
  Pout = spXORN(varargin{:});  % call the general XOR function

  % Compute switching activity
  Esw = 2 * Pout * (1 - Pout);

  % Display results
  fprintf('Switching activity for N-input XOR gate:\n');
  disp(cell2mat(varargin));
  fprintf('Esw = %.4f\n', Esw);
endfunction



% 2-input NAND gate truth table
% 0 0:1
% 0 1:1
% 1 0:1
% 1 1:0
%% signal probability calculator for a 2-input XOR gate
%% input1sp: signal probability of first input signal
%% input2sp: signal probability of second input signal
%%        s: output signal probability
function s=sp2NAND(input1sp, input2sp)
  printf("NAND Gate for input probabilities (%f %f):\n",input1sp,input2sp)
  s = 1 - input1sp*input2sp;
endfunction

function Esw = sw2NAND(input1sp, input2sp)
  % Compute 2-input NAND probability
  Pout = sp2NAND(input1sp, input2sp);

  % Compute switching activity
  Esw = 2 * Pout * (1 - Pout);

  % Display results
  fprintf('Switching activity for 2-input NAND gate:\n');
  fprintf('Inputs: %.4f, %.4f\n', input1sp, input2sp);
  fprintf('Esw = %.4f\n', Esw);
endfunction


function s=sp3NAND(input1sp, input2sp, input3sp)
  printf("NAND Gate for input probabilities (%f %f %f):\n",input1sp,input2sp,input3sp)
  s = 1 - input1sp*input2sp*input3sp;
endfunction

function Esw = sw3NAND(input1sp, input2sp, input3sp)
  % Compute 3-input NAND probability
  Pout = sp3NAND(input1sp, input2sp, input3sp);

  % Compute switching activity
  Esw = 2 * Pout * (1 - Pout);

  % Display results
  fprintf('Switching activity for 3-input NAND gate:\n');
  fprintf('Inputs: %.4f, %.4f, %.4f\n', input1sp, input2sp, input3sp);
  fprintf('Esw = %.4f\n', Esw);
endfunction


function s = spNAND(varargin)

  % Compute AND probability first
  pand = spAND(varargin{:});  % pass all inputs to spAND

  % NAND probability = 1 - AND probability
  s = 1 - pand;

  % Display result
  %fprintf('NAND Gate for input probabilities:\n');
  %disp(cell2mat(varargin));
  fprintf('Result: %.4f\n', s);
endfunction

function Esw = swNAND(varargin)
  % Compute N-input NAND probability
  Pout = spNAND(varargin{:});  % call the general NAND function

  % Compute switching activity
  Esw = 2 * Pout * (1 - Pout);

  % Display results
  fprintf('Switching activity for N-input NAND gate:\n');
  disp(cell2mat(varargin));
  fprintf('Esw = %.4f\n', Esw);
endfunction






% 2-input NOR gate truth table
% 0 0:1
% 0 1:0
% 1 0:0
% 1 1:0
%% signal probability calculator for a 2-input NOR gate
%% input1sp: signal probability of first input signal
%% input2sp: signal probability of second input signal
%%        s: output signal probability
function s=sp2NOR(input1sp, input2sp)
  printf("NOR Gate for input probabilities (%f %f):\n",input1sp,input2sp)
  s = (1-input1sp)*(1-input2sp);
endfunction

function Esw = sw2NOR(input1sp, input2sp)
  % Compute 2-input NOR probability
  Pout = sp2NOR(input1sp, input2sp);

  % Compute switching activity
  Esw = 2 * Pout * (1 - Pout);

  % Display results
  fprintf('Switching activity for 2-input NOR gate:\n');
  fprintf('Inputs: %.4f, %.4f\n', input1sp, input2sp);
  fprintf('Esw = %.4f\n', Esw);
endfunction


function s=sp3NOR(input1sp, input2sp, input3sp)
  printf("NOR Gate for input probabilities (%f %f %f):\n",input1sp,input2sp,input3sp)
  s = (1-input1sp)*(1-input2sp)*(1-input3sp);
endfunction

function Esw = sw3NOR(input1sp, input2sp, input3sp)
  % Compute 3-input NOR probability
  Pout = sp3NOR(input1sp, input2sp, input3sp);

  % Compute switching activity
  Esw = 2 * Pout * (1 - Pout);

  % Display results
  fprintf('Switching activity for 3-input NOR gate:\n');
  fprintf('Inputs: %.4f, %.4f, %.4f\n', input1sp, input2sp, input3sp);
  fprintf('Esw = %.4f\n', Esw);
endfunction


function s = spNOR(varargin)

  % Convert input arguments to vector
  p = cell2mat(varargin);

  % Display input probabilities
  fprintf('NOR Gate for input probabilities:\n');
  disp(p);

  % Compute NOR probability = product of (1 - each input probability)
  s = prod(1 - p);

  % Display result
  %fprintf('Result: %.4f\n', s);
endfunction

function Esw = swNOR(varargin)
  % Compute N-input NOR probability
  Pout = spNOR(varargin{:});  % call the general NOR function

  % Compute switching activity
  Esw = 2 * Pout * (1 - Pout);

  % Display results
  fprintf('Switching activity for N-input NOR gate:\n');
  disp(cell2mat(varargin));
  fprintf('Esw = %.4f\n', Esw);
endfunction


function s = spNOT(input1sp)
  s = 1 -input1sp;
endfunction

function Esw = swNOT(input1sp)
  % Compute 2-input NOR probability
  Pout = spNOT(input1sp);

  % Compute switching activity
  Esw = 2 * Pout * (1 - Pout);

  % Display results
  fprintf('Switching activity for NOT gate:\n');
  fprintf('Inputs: %.4f\n', input1sp);
  fprintf('Esw = %.4f\n', Esw);
endfunction


function s = spXNOR(varargin)
  % Count the number of inputs provided
  n = length(varargin);

  % Print the number of inputs
  printf("XNOR Gate for %d input probabilities:\n", n);

  % Convert the cell array of inputs to a numeric vector and display it
  disp(cell2mat(varargin));

  % Convert the variable input arguments to a numeric vector for calculations
  p = cell2mat(varargin);

  % Compute the signal probability for N-input XNOR using the general formula:
  % P(Y=1) = 0.5 * (1 + product(1 - 2*p_i))
  s = 0.5 * (1 + prod(1 - 2 .* p));
endfunction




