function [pG_factor, SI_factor, nL_factor] = findOptimal(factors, P, tspan, inp, tstart, tfinal, y0)
    % FINDOPTIMAL performs search over specified multiplication
    %   factors to find the optimal combination of parameters that minimizes the
    %   absolute difference between the steady-state values and target values for
    %   glucose and insulin levels.
    %  [pG_factor, SI_factor, nL_factor] = FINDOPTIMAL(factors, P, tspan, inp, tstart, tfinal, y0)
    %
    % INPUTS:
    %   factors: Vector of multiplication factors for adjusting model parameters.
    %   P: Initial parameter vector.
    %   tspan: Time span for ODE integration.
    %   inp: Input vector for the ODE system.
    %   tstart: Start time for ODE integration.
    %   tfinal: Final time for ODE integration.
    %   y0:Initial conditions for the ODE system.
    %
    % OUTPUTS:
    %   pG_factor: Index for optimal multiplication factor for pG in factor list.
    %   SI_factor: Index for optimal multiplication factor for SI in factor list.
    %   nL_factor: Index for optimal multiplication factor for nL in factor list.

    % Target values for glucose and insulin
    tar_gluc = 7.10;
    tar_ins= 16.6;
    
    % Extract parameters from input vector P
    nL = P(8);
    pG = P(1);
    SI = P(2);
    
    % Structure to save data
    Y = struct('y', cell(length(factors),length(factors), length(factors)), 't', cell(length(factors),length(factors), length(factors)));
    dev_gluc = zeros(length(factors), length(factors), length(factors));
    dev_ins = zeros(length(factors), length(factors), length(factors));
    
    % Loop over all combinations of multiplication factors
    for l=1:length(factors)
        for n=1:length(factors)             
            for m=1:length(factors)     
                % Change the parameters based on multiplication factors
                P(8) = nL * factors(l);
                P(1) = pG * factors(n);
                P(2) = SI * factors(m);
                
                % Call solver
                [t,y] = ode45(@(t,y) ODE_fun(t,y,P,tspan,inp),[tstart,tfinal], y0);
                
                % Store cuurent results:
                Y(n, m).y = y;
                Y(n, m).t = t;

                % Get steady state value:
                ss_gluc = y(end,1);
                ss_ins = y(end,7);
                
                % Caclculate absolute difference between steady state and
                % target value.
                dev_gluc(l, n, m) = abs(tar_gluc - ss_gluc);
                dev_ins(l, n, m)  = abs(tar_ins-ss_ins);
                l, n, m
            end
        end
    end
    
    % figure for heatmap
    figure
    
   % Initialize the lowest minimum as a highest possible value
   lowest_Min = 2;
   
    % find the minimum
    for l=1:length(factors)
        Min_gluc = min(min(dev_gluc(l,:,:)));
        Max_gluc = max(max(dev_gluc(l,:,:)));
        % Normalize glucose deviations
        dev_gluc_norm=(dev_gluc(l,:,:)-Min_gluc)/(Max_gluc-Min_gluc);

        Min_ins = min(min(dev_ins(l,:,:)));
        Max_ins = max(max(dev_ins(l,:,:)));
        % Normalize insulin deviations
        dev_ins_norm=(dev_ins(l,:,:)-Min_ins)/(Max_ins-Min_ins);
        
        % Total error combining glucose and insulin deviations  
        dev_sum= dev_gluc_norm + dev_ins_norm;
        dev = squeeze(dev_sum(1,:,:));
        current_Min = min(min(dev));
        
        % Find minimum and corresponding factors      
        if current_Min <= lowest_Min
            lowest_Min = current_Min;
            nL_factor = l;
            [pG_factor, SI_factor] = find(dev == lowest_Min);
            
        end
        
        % Plot heatmaps of all combinations
        subplot(3,4,l)
        x = factors*SI;
        y = factors*pG;
        imagesc(x, y, dev)

        % Customize plot appearance
        set(gca,'YDir','normal')
        xlabel('$S_{I}$', 'Interpreter','latex', 'Fontsize', 11, 'Fontname', 'Times')
        ylabel('$p_{G}$', 'Interpreter','latex', 'Fontsize', 12, 'Fontname', 'Times')
        myTitle  =  {sprintf('$n_{L}=%.1f$', factors(l)*nL)   ''  } ;
        title(myTitle, 'Interpreter', 'latex', 'Fontsize', 13, 'Fontname', 'Times');
        
    end
    % Add colorbar to the last subplot
    ax = subplot(3,4,l+1);
    set(ax,'Visible','off');
    cb = colorbar(); 
    ylabel(cb,'Absolute difference','FontSize',11,'Rotation',270, 'Fontname', 'Times')
    cb.Label.VerticalAlignment = "bottom";
end
    