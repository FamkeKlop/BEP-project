% Define the step_input function here
function u = step_fun(t, t_step_start, t_step_end, u_step)
    % STEP_FUN generates a step input function
    % Inputs:
    %   t: Time vector
    %   t_step: Time at which the step occurs
    %   u_step: Magnitude of the step

    % Initialize the step input vector
    u = zeros(size(t));

    % Set the step input value after the step time
    u((t >= t_step_start) & (t <= t_step_end)) = u_step;
end