1;
function test_lab21 (input1, input2)
  % Simple testbench for the lab21 function

  fprintf(' a | b | c || e f d\n');
  fprintf('--------------------\n');

  for a = 0:1
    for b = 0:1
      for c = 0:1
        d_model = lab21(a,b,c);
        fprintf(' %d | %d | %d || %d  %d  %d\n', a, b, c, d_model(1), d_model(2), d_model(3));
      end
    end
  end

endfunction

