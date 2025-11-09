1;
function SignalsTable = myCircuit1(a, b, c)

  % signals: 1=a, 2=b, 3=c, 4=f, 5=e, 6=d
  SignalsTable = zeros(1,6); % 3 inputs and 3 outputs
  % assigning all the inputs to the signal table
  SignalsTable(1) = a;
  SignalsTable(2) = b;
  SignalsTable(3) = c;

  % Creating port structures, we assign input/output positions in the signal table
  E1.type = 'AND'; E1.inputs = [1,2]; E1.output = 5;   % e = a AND b
  E2.type = 'NOT'; E2.inputs = [3];   E2.output = 6;   % f = NOT c
  E3.type = 'AND'; E3.inputs = [5,6]; E3.output = 4;   % d = e AND f
  ElementsTable = {E1, E2, E3};

  for i = 1:length(ElementsTable)
    element = ElementsTable{i};
    switch element.type
      case 'AND'
        % in1 goes at element.inputs(1) position of signal table
        % Same with the rest
        in1 = SignalsTable(element.inputs(1));
        in2 = SignalsTable(element.inputs(2));
        SignalsTable(element.output) = spAND(in1, in2);
      case 'NOT'
        in1 = SignalsTable(element.inputs(1));
        SignalsTable(element.output) = spNOT(in1);
    endswitch
  endfor

  fprintf('a=%d  b=%d  c=%d  ->  e=%d  f=%d  d=%d\n', ...
          SignalsTable(1), SignalsTable(2), SignalsTable(3), ...
          SignalsTable(5), SignalsTable(6), SignalsTable(4));

endfunction

