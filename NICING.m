clear all;
%% Presets:
G_0=0; Q_0=0;
P1_0=0; P2_0=0;
ISC_0=0; Qlocal_0=0; 
I_0=0;
y0 = [G_0;Q_0;P1_0;P2_0;ISC_0;Qlocal_0;I_0];

%% Parameters and variables:
% Original model parameters
pG = 0.003;     % [min-1]
SI = 0.5e-3;    % [L/mU/min] 
aG = 0;         % [L/mU]
Vg = 0.4;       % [L/kg]
EGP = 0.033;    % [mmol/kg/min]
CNS = 0.088;    % [mmol/kg/min]
aI = 0.0017;    % [L/mU]
nL = 0.39;      % [min-1]
xL = 0.67;      % [min-1]
nI = 0.025;     % [min-1]
PNA = 4;        % [days] 
Vp = 0.047;     % [L/kg]
mbody = 0.681;  % [kg]
d1 = 0.017;     % [min-1]
d2 = 0.014;     % [min-1]

P = [pG; SI; aG; Vg; EGP; CNS; aI; nL; xL; nI; PNA; Vp; mbody; d1; d2];

% Simulation settings
tstart = -1000; % [s]
tfinal = 600;  % [s]
tspan = tstart:0.1:tfinal;


%% Variable input
IV_flow = 0.6*mbody;

% step_fun(timespan, start_step, end_step, size_step);

Pex = step_fun(tspan, 0, 0, 0);                           % [mmol/min] enteral glucose: variable input 
% Pex = step_fun(tspan, 0, 20, 0.257);
Ptpn = step_fun(tspan, 0, 0, 0);                          % [mmol/min] intravenous glucose: variable input
uex = step_fun(tspan, tstart, tfinal, IV_flow);           % [mU/min] exogenous insulin: variable input
Iinput = step_fun(tspan, 0, 0, 0);                        % [mU/min] Subcutaneous insulin input

% Collecting parameters, and input parameters
inp = [Pex; Ptpn; uex; Iinput];

%% Solvers presets:
factors = 0.4:0.4:4;
%factors = [1:0.5:2];

%% Solvers:
% Choose only one of the sovlers, otherwise ouputs will be overwritten

% ----------  Regular solver ---------- 
[t,y] = ode45(@(t,y) ODE_fun(t,y,P,tspan,inp),[tstart,tfinal], y0);

% ---------- Parameter sensitivity analysis solver: ---------- 
%Y = PSA(factors, P, tspan, inp, tstart, tfinal, y0);

% ---------- Varying SI, pG and nL: ---------- 

%% Plotting presets
% Options for toPlot: 'glucose', 'peripheral insulin', 'stomach', 'Gut',
% 'subcutaneous space', 'local insulin', and 'insulin'
toPlot = 'glucose';
plotStart = tstart;
plotEnd = tfinal;

%% Plots
% Choose plot that correspons to generated data:

% ---------- Plot glucose and insulin from singular solver data with target values plotted ---------- 
plotGlucIns(y, t, plotStart, plotEnd);

% ---------- Plot parameter sensitivity analysis data ---------- 
% plotPSA(Y, factors, toPlot, plotStart, plotEnd);

%% pG, SI and nL analysis:

% Find optimal pG, SI and nL factors and plot heatmaps of all possible
% combinations
[pG_factor, SI_factor, nL_factor] = findOptimal(factors, P, tspan, inp, tstart, tfinal, y0);



%% Use new factors for pG, SI  and nL
% Caclulate new optimal paramters:
pG_opt = factors(pG_factor)*pG;
SI_opt = factors(SI_factor)*SI;
nL_opt = factors(nL_factor)*nL;

% Set new factors to paramter list
P(1) = pG_opt;
P(2) = SI_opt;
P(8) = nL_opt;

% Optional inputs:
% Pex =  step_fun(tspan, 0, 20, 0.257) + step_fun(tspan, 240, 280, 0.257);
inp = [Pex; Ptpn; uex; Iinput];

% Call solver
[t,y] = ode45(@(t,y) ODE_fun(t,y,P,tspan,inp),[tstart,tfinal], y0);
%% plot new found optimum
plotGlucIns(y, t, plotStart, plotEnd);
