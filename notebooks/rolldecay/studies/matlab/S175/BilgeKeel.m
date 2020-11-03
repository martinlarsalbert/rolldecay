function [Bp44BK_N0,Bp44BK_H0,B44BK_L,B44BKW0] = BilgeKeel(wE,fi_a,V)
global vcg B d A bBK R g OG Ho ra %constants only!!
%ITTC definitions

%B44BK = B44BK_N0 + B44BK_H0 + B44BK_L + B44BK_W;

%%

j    =   1;                 % Station number [-]
tata =   A(j)/(B*d);

% T=24; wE   = pi*1/T;        % circular frequency
%
% fi_a =   2*pi/180;          % roll amplitude !!rad??



% Normal Force component (ITTC)
f    =   1+0.3*exp(-160*(1-tata));
l    =   d*sqrt((Ho-(1-sqrt(2)/2)*R/d)^2+(1-OG/d-(1-sqrt(2)/2)*R/d)^2) % distance from CoG to tip of bilge keel
CD   = 22.5*bBK/(pi*l*fi_a*f)+2.4;
Bp44BK_N0 = 8/(3*pi)*ra*l^3*wE*fi_a*bBK*f*CD;

%%
% Hull pressure component
So = 0.3*pi*l*fi_a*f/bBK+1.95;
m1 = R/d; m2 = OG/d; m3 = 1-m1-m2; m4 = Ho-m1;
m5 = (0.414*Ho+0.0651*m1^2-(0.382*Ho+0.0106)*m1)/((Ho-0.215*m1)*(1-0.215*m1));
m6 = (0.414*Ho+0.0651*m1^2-(0.382+0.0106*Ho)*m1)/((Ho-0.215*m1)*(1-0.215*m1));

if So > 0.25*pi*R
    m7 = So/d-0.25*pi*m1;
else
    m7=0;
end

if So > 0.25*pi*R
    m8 = m7+0.414*m1;
else
    m8 = m7+1.414*m1*(1-cos(So/R));
end

Ao=(m3+m4)*m8-m7^3;
Bo=m2^2/(3*(Ho-0.215/m1))+(1-m1)^2*(2*m3-m2)/(6*(1-0.215*m1))+m1*(m3*m5+m4*m6);
Cp_minus = -22.5*bBK/(pi*l*fi_a*f)-1.2;
Cp_plus  = 1.2;

Bp44BK_H0 =4/(3*pi)*ra*l^2*wE*fi_a*d^2*(-Ao*Cp_minus+Bo*Cp_plus);

%% Ikeda 1994
% bilge keel generated Lift     %Fartberoende??
l1     = l+bBK/2;               %Lift Force
u      = l1*fi_a*wE;            %tangential velocity
alpha  = atan(u/V);             %flow velocity?
Vr     = sqrt(V^2+u^2);         %-''-

LBK=pi*ra*alpha*Vr^2*bBK^2/2;   %lift

B44BK_L=2*LBK*l1/(fi_a*wE);      %

%%
% wave making contribution from bilge keels, normally very small...,
% non-dimensional!!!!!

C_BK    = bBK/B;                %estimation according to ITTC
lBK     = l-bBK;                % needs to be verified!!!!
fi      = fi_a;

dBK     = lBK*((2*d/B)/sqrt(1+(2*d/B)^2)*cos(fi)-sin(fi)/(1+(2*d/B)^2));

B44BKW0 = C_BK*exp(-wE^2/g*dBK); %non dimensional wave damping from BK, ITTC
