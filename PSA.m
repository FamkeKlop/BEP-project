function [X] = PSA(factors, P, tspan, inp, tstart, tfinal, y0)
    % PSA - Parameter Sensitivity Analysis
    % Perform a parameter sensitivity analysis by varying each parameter
    % according to given multiplication factors.
    %
    % INPUT:
    %   factors: Multiplication factors for each parameter.
    %   P:       Vector of original parameter values.
    %   tspan:   Time span for the ODE solver.
    %   inp:     Additional input for the ODE system.
    %   tstart:  Start time for the ODE solver.
    %   tfinal:  Final time for the ODE solver.
    %   y0:      Initial conditions for the ODE system.
    %
    % Output:
    %   Y: Struct array containing ODE solution for each combination of
    %      parameters and multiplication factors.
    %   T: Struct array containing corresponding time values.

    % Initialize output structures
    Y = struct('y', cell(length(P),length(factors)), 't', cell(length(P),length(factors)));

        for i=1:length(P)               % Loop over all parameters
            p_i_old = P(i);             % Current parameter to be changed

            for f=1:length(factors)     % Loop over all multiplication factors
                P(i) = p_i_old * factors(f);
                
                % Call ODE solver
                [t,y] = ode45(@(t,y) ODE_fun(t,y,P,tspan,inp),[tstart,tfinal], y0);
                % Store data: each row holds the results for the change of one
                % parameter. Every collumn is the different multiplications of
                % one paramter.
                Y(i, f).y = y;
                Y(i, f).t = t;
                
                P(i) = p_i_old;         % Reset the paramter
            end
        end
        
        X = Y;
    
end