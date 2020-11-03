function [B44L] = HullLift(V)
%V=5
global B d OG ra L C_mid%constants only!!

% lo   = 0.3*d;
% lR   = 0.5*d;
% K    = 0.1;         %!! depends on CM
%
%
%
% kN   = 2*pi*d/L+K*(4.1*B/L-0.045);
% B44L = ra/2*V*L*d*kN*lo*lR*(1-1.4*OG/lR+0.7*OG/(lo*lR)) %ITTC, Himeno
% %B44L = ra/2*V*L*d*kN*lo*lR*(1+1.4*abs(OG)/lR+0.7*OG^2/(lo*lR))
% %
%



%Journee
lo   = 0.3*d;
lR   = 0.5*d;
K=106*(C_mid-0.91)^2-700*(C_mid-0.91)^3;
kN   = 2*pi*d/L+K*(4.1*B/L-0.045);

B44L = ra/2*V*L*d*kN*lo*lR*(1-1.4*(OG)/lR+0.7*OG^2/(lo*lR));
