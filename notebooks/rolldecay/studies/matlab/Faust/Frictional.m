function [B44F] = Frictional(wE,fi_a,V)

global B d OG ra visc Cb L %constants only!!

%
T_R=2*pi/wE;
Sf   = L*(1.7*d+Cb*B); %Wetted surface approx
r_f  = 1/pi*((0.887+0.145*Cb)*(Sf/L)-2*OG);

Rn = 0.512*(r_f/fi_a)^2*wE/visc
Cf = 1.328*Rn^-0.5+0.14*Rn^-0.114;
B44F0=0.5*ra*r_f^3*Sf*Cf;
B44F=B44F0*8/(3*pi)*fi_a*wE*(1+4.1*V/(wE*L)) 