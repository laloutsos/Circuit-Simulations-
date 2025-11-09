function MCpi()
    % MCpi: Estimation of the constant pi using Monte Carlo simulation
    % We define a square with side length a = 1 and an inscribed circle with radius r = a/2

    a = 1;          % side length of the square
    r = a / 2;      % radius of the circle
    cx = r; cy = r; % coordinates of the circle's center

    % Different values of N (number of random points)
    N_values = [10, 100, 1000, 5266, 10000];
    pi_estimates = zeros(size(N_values));

    fprintf('Monte Carlo estimation of pi:\n');
    fprintf('--------------------------------\n');

    for i = 1:length(N_values)
        N = N_values(i);

        % Generate N random points inside the square [0, a] x [0, a]
        x = rand(1, N) * a;
        y = rand(1, N) * a;

        % Check how many points are inside the circle
        d = sqrt((x - cx).^2 + (y - cy).^2);
        inside = sum(d <= r);

        % Compute the approximation of pi
        pi_est = 4 * (inside / N);
        pi_estimates(i) = pi_est;

        fprintf('N = %5d  -->  Approximation of pi = %.6f\n', N, pi_est);
    end

    % Plot the results
    figure;
    plot(N_values, pi_estimates, 'o-b', 'LineWidth', 1.5);
    hold on;
    plot([min(N_values), max(N_values)], [pi, pi], '--r', 'LineWidth', 1.2);
    text(N_values(end)*0.9, pi+0.01, 'actual π', 'Color', 'r');
    xlabel('Number of points N');
    ylabel('Approximation of pi');
    title('Monte Carlo approximation of the constant pi');
    grid on;

    fprintf('--------------------------------\n');
    fprintf('Execution finished.\n');
end
