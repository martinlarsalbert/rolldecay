clear all;
close all;
clc;

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
% ND_factor = wE/(2*ra*disp*g*(16*ScaleF-vcg));   % Nondimensiolizing factor of B44

Wave=[];
Bilgekeel=[];
Friction=[];
Lift=[];
EDDY=[]

B44BK_N0vec = [];
B44BK_H0vec = [];
B44BK_Lvec  = [];
B44BKW0_vec = [];

Vvec=[0:1:10];
for V=Vvec

    [B44E] = Eddy(wE,fi_a,V)
    EDDY=[EDDY B44E]

end

figure();
plot(Vvec,EDDY);

%%
V=0;
w_hats = linspace(0,1,100);
EDDY=[];
for w_hat=w_hats

    w=sqrt(2)*w_hat/sqrt(B/g);
    [B44E] = Eddy(w,fi_a,V)
    EDDY=[EDDY B44E]

end

figure();
plot(w_hats, ND_factorB*EDDY);
