% System of ODEs
function dYdt = ODE_fun(t,Y,P,tspan,inp)

% Assign state variables
G = Y(1);
Q = Y(2);
P1 = Y(3);
P2 = Y(4);
I_SC = Y(5);
Q_local = Y(6);
I = Y(7);

% Parameter values 

% Original model
Pex = interp1(tspan, inp(1,:), t');         % [mmol/min] variable input
Ptpn = inp(2);                              % [mmol/min] variable input
uex = inp(3);                               % [mU/min] variable input
Iinput = inp(4);                            % [mU/min] Subcutaneous insulin input

pG = P(1);          % [min-1]
SI = P(2);          % [L/mU/min]
aG = P(3);          % [L/mU]
Vg = P(4);          % [L/kg]
EGP = P(5);         % [mmol/kg/min]
CNS = P(6);         % [mmol/kg/min]
aI = P(7);          % [L/mU]
nL = P(8);          % [min-1]
xL = P(9);          % [min-1]
nI = P(10);         % [min-1]
PNA = P(11);        % [days] 
Vp = P(12);         % [L/kg]
mbody = P(13);      % [kg]
d1 = P(14);         % [min-1]
d2 = P(15);         % [min-1]

% Calculate parameters
mbrain = 0.14*mbody;                % [kg]
GFR = 0.45+0.24*mbody+0.18*PNA/7;   % [mL/min]
nK = 1/Vp * (0.9*GFR*10^-3)/0.6;    % [min-1]
Vq = ((492*PNA^-0.09)-Vp)*10^-3;    % [L/kg]
nC = nI*Vp/Vq * 1;                  % [min-1] (Qss/Iss)=0.5 --> (Iss/Qss-1)=1; given value: 0.025 

uen = max([4.2, -1.5+1.9*G]);       % [mU/L/kg/min] Male
%uen = max([2.2, -0.37+0.86*G]);    % [mU/L/kg/min] Female

% Subcutaneous Insulin plugin
ks2 = 0.0104;   % [min-1]
k3 = 0.06;      % [min-1]
kdi = 0.006;    % [min-1]
% 
% t1 = -nL*I/(1+aI*I)
% t2 = -nK*I
% t3 = nI*(I-Q)
% t5 = (1-xL)*uen

% Differential Equations
dG = -pG*G - SI*G*Q/(1+aG*Q)+(Ptpn+d2*P2+EGP*mbody-CNS*mbrain)/(Vg*mbody);
dQ = nI*Vp/Vq*(I-Q)-nC*Q/(1+aG*Q);
dP1 = Pex - d1*P1;
dP2 = d1*P1 - d2*P2;
dI_SC = Iinput - ks2*I_SC;
dQ_local = ks2*I_SC - (k3+kdi)*Q_local;
dI = -nL*I/(1+aI*I)-nK*I - nI*(I-Q) + uex/(Vp*mbody) + (1-xL)*uen + k3*Q_local;

dYdt = [dG;dQ;dP1;dP2;dI_SC;dQ_local;dI];
end