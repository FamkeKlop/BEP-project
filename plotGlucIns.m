function x = plotGlucIns(y, t, plotStart, plotEnd)
    % PLOTGLUCINS Visualizes glucose and insulin levels over a specified time range.
    %   x = PLOTGLUCINS(y, t, plotStart, plotEnd) generates two subplots
    %   representing the glucose and insulin levels over the specified time
    %   range [plotStart, plotEnd]. The function also marks target values
    %   for both glucose and insulin.
    %
    %   Inputs:
    %       y: Matrix containing simulation results for glucose and insulin levels.
    %       t: Time vector corresponding to simulation results.
    %       plotStart: Starting time for plotting.
    %       plotEnd: Ending time for plotting.

    to_plot = [1, 7];                                    % Indices for glucose and insulin in 'y'
    
    % Corresponding target values
    desired_values = [7.10, 16.6];
    y_labels = ["glucose [mmol/L]", "Insulin [mU/L]"]; % Labels for subplots
    
    % Indices for time range [plotStart, plotEnd]
    tstart = find(t==plotStart);
    tend =  find(t==plotEnd);
    
    figure
    
     % Loop over variables to plot
    for i=1:length(to_plot)
        
        % Subplot for the current variable
        subplot(2,1,i);
        
        % Plot simulation results for the specified time range
        plot(t(tstart:tend), y(tstart:tend,to_plot(i)), 'linewidth', 1.5);
        
        % Customize plot appearance
        set(gca, 'Fontsize', 11, 'Fontname', 'Times')
        xlim([plotStart plotEnd]);
        yline(desired_values(i), '--', 'Target', 'linewidth', 1, 'Fontsize', 11, 'Fontname', 'Times', 'FontWeight', 'bold')
        xlabel('Time [min]', 'Fontsize', 11, 'FontWeight', 'bold')
        ylabel(y_labels(i), 'Fontsize', 11, 'FontWeight', 'bold');
        grid on;
    end
    % Dummy output variable
    x=0;
end