1;
function retval = test_myCircuit1(input1sp,input2sp)

  d_switching_activity = lab32montecarlo(input2sp);
  if input1sp == 1
    for a = 0:1
      for b = 0:1
        for c = 0:1
          d_model = myCircuit1(a,b,c);
          d_modell = d_model(4);
          %fprintf(' %d | %d | %d ||     %d\n', a, b, c, d_model);
        end
      end
    end

  elseif input1sp == 2
    d_switching_activity = lab31montecarlo(input2sp);
    for a = 0:1
      for b = 0:1
        for c = 0:1
          d_model = CircuitMaker('myCircuit1.txt', a,b,c);
          %fprintf(' %d | %d | %d ||     %d\n', a, b, c, d_model);
        end
      end
    end

  elseif input1sp == 3
    d_switching_activity = lab33montecarlo(input2sp);
    for a = 0:1
      for b = 0:1
        for c = 0:1
          d_model = TopologicalCircuitMaker('myUnsortedCircuit1.txt', a,b,c);
          %fprintf(' %d | %d | %d ||     %d\n', a, b, c, d_model);
        end
      end
    end
  elseif input1sp == 4
    d_switching_activity = lab21montecarlo(input2sp);
    test_lab21(1, 2);
  else
    error('Invalid input1sp value. Must be 1, 2, 3, or 4.');
  end





  fprintf('\nSimulation completed.\n');

endfunction

