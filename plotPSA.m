function x = plotPSA(Y, factors, toPlot, plotStart, plotEnd)
    % PLOTPSA Visualize simulation parameter sensitivity analysis results.
    %   x = PLOTPSA(Y, factors, toPlot) generates a multi-plot visualization
    %   of simulation results for a set of parameters. The varying 
    %   parameters are specified in the 'factors'
    %   vector. The user can choose which physiological variable to plot
    %   using the 'toPlot' input. The time range for plotting is determined
    %   by 'plotStart' and 'plotEnd'.
    %
    %   Inputs:
    %       Y: Matrix containing simulation results for different parameter combinations.
    %       factors: Vector specifying which parameters are varied during the simulation.
    %       toPlot: String specifying which physiological variable to plot.
    %       plotStart: Starting index of the time range to plot.
    %       plotEnd: Ending index of the time range to plot.
    
    
    
     % Latex symbols for physiological variables
    cp_latex = {'$p_{G}$', '$S_{I}$', '$\alpha_{G}$', '$V_{g}$', '$EGP$', '$CNS$', '$\alpha_{I}$', '$n_{L}$', '$x_{L}$', '$n_{I}$' '$PNA$', '$V_{p}$', '$m_{body}$'};
    % Parameter names corresponding to changing parameters
    changing_paramters = {'pG', 'SI', 'aG', 'Vg', 'EGP', 'CNS', 'aI', 'nL', 'xL', 'nI', 'PNA' 'Vp', 'mbody'};

     % Switch based on the physiological variable to plot
    switch toPlot
        case 'glucose'
            tb_plotted = 1;
            ylabelName = 'glucose [mmol/L]';
        case 'peripheral insulin'
            tb_plotted = 2;
            ylabelName = 'Insulin [mU/L]';
        case 'stomach'
            tb_plotted = 3;
            ylabelName = 'glucose [mmol]';
        case 'Gut'
            tb_plotted = 4;
            ylabelName = 'glucose [mmol]';
        case 'subcutaneous space'
            tb_plotted = 5;
            ylabelName = 'insulin [mmol]';
        case 'local insulin'
            tb_plotted = 6;
            ylabelName = 'glucose [mmol]';
        case 'insulin'
            tb_plotted = 7;
            ylabelName = 'Insulin [mU/L]';
    end

    % Create a tiled layout for subplots
    tcl = tiledlayout(5,3);

    % Loop over all paramters that are changed
    for i=1:length(changing_paramters)
        % Create a subplot in the tiled layout        
        nexttile(tcl)

        % Set color vector
        cStart = [0 0.2 0.8];
        cEnd = [1 0 0 ];
        c = interp1([1;length(factors)],[cStart;cEnd],(1:length(factors))');

        % loop over every change of one parameter
        hold on;
        for n=1:length(factors)
            set(gca, 'Fontsize', 16, 'Fontname', 'Times');
            
            tstart = find(Y(i, n).t==plotStart);
            tend =  find(Y(i, n).t==plotEnd);
            % Plot the simulation results
            pl = plot(Y(i, n).t(tstart:tend), Y(i, n).y(:,tb_plotted), 'Color', c(n,:), 'Linewidth', 0.75);
            plo(n) = pl(1);
            %legend({'standard', '*1.5', '*2', '*3'})

             % Highlight the standard condition with a thicker yellow line
            if factors(n) == 1
                pl_mid = plot(Y(i, n).t(:), Y(i, n).y(:,tb_plotted), 'Color', [0.9290 0.6940 0.1250], 'Linewidth', 2);
            end

            % set plot limits
            ylim([0 12]);
            xlim([plotStart plotEnd]);
        end

        % Add titles, labels, and legends to each subplot
        title(sprintf('%s', changing_paramters{i}), 'Interpreter','latex');
        grid on;
        xlabel('Time [min]', 'Fontsize', 11, 'FontWeight', 'bold');
        ylabel(ylabelName, 'Fontsize', 11);
        title(strcat('\boldmath', cp_latex{i}), 'Interpreter','latex', 'Fontsize', 20, 'FontWeight', 'bold');

        % Add legend to the last subplot
        if i == length(changing_paramters)
            lg = legend([plo(1), pl_mid, plo(end)], {'0.5', 'standard', '2'}, 'Fontsize',14);
            set(lg,'Location','best')
        end
    end
    % Dummy output variable
    x = 0;
end