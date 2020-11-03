clear global
global vcg B d A bBK R g OG Ho ra visc Cb L ScaleF C_mid%constants only!!

 %constants only!!

ScaleF =  1%/29.565;                  % Scale Factor [-]
visc =   1.15*10^-6;                  % [m2/s], kinematic viscosity
Cb   =   0.61;                        % Block coeff
L    =   220*ScaleF;                  % Length
vcg  =   14.4*ScaleF;                 % roll axis (vertical centre of gravity) [m]
vcg  =   14.9*ScaleF;                 % roll axis (vertical centre of gravity) [m]
B    =   32.26*ScaleF;                % Breadth of hull [m]
d    =   9.5*ScaleF;                  % Draught of hull [m]
A    =   0.93*B*d;                    % Area of cross section of hull [m2]
bBK  =   0.4*ScaleF;                  % breadth of Bilge keel [m] !!(=height???)
R    =   5*ScaleF;                    % Bilge Radis
g    =   9.81;
C_mid=   0.93;

OG = -1*(vcg-d)%*0.8;                    % distance from roll axis to still water level
Ho = B/(2*d);                  % half breadth to draft ratio
ra   = 1025;                   % density of water

%locals
LBK  = L/4;                    % Approx
disp = L*B*d*Cb;               % Displacement

% variables!!

T=27.6*sqrt(ScaleF); wE   = 2*pi*1/T;        % circular frequency
%T=23*sqrt(ScaleF); wE   = 2*pi*1/T;        % circular frequency
fi_a =   10*pi/180;            % roll amplitude !!rad??
%V    =   5;                  % Speed

ND_factorB = sqrt(B/(2*g))/(ra*disp*(B^2));   % Nondimensiolizing factor of B44
%ND_factor = 1/(2*wE*(T/(2*pi))^2*disp*g*(16-vcg));   % Nondimensiolizing factor of B44
ND_factor = wE/(2*ra*disp*g*(16*ScaleF-vcg));   % Nondimensiolizing factor of B44

Wave=[];
Bilgekeel=[];
Friction=[];
Lift=[];
EDDY=[]

B44BK_N0vec = [];
B44BK_H0vec = [];
B44BK_Lvec  = [];
B44BKW0_vec = [];

V=10
% components
% wave
bw44 = Bw_4444(wE,V);

%bilge keel
[Bp44BK_N0,Bp44BK_H0,B44BK_L,B44BKW0] = BilgeKeel(wE,fi_a,V);

B44BK_N0 = Bp44BK_N0 * LBK%
B44BK_H0 = Bp44BK_H0 * LBK%
B44BK_L  = B44BK_L

B44_BK = B44BK_N0+B44BK_H0+B44BK_L

B44BKW0 = B44BKW0/ND_factorB;

% Frictional
B44F = Frictional(wE,fi_a,V)

% Hull lift
B44L = HullLift(V)

B44E = Eddy(wE,fi_a,V)

a = 1;
