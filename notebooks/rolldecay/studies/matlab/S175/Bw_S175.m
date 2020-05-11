function [bw44] = Bw_S175(w,V)

global g d
    
    Bw0=Bw0_S175(w);
    OMEGA=w*V/g;
    zeta_d=w^2*d/g;
    A1=1+zeta_d^(-1.2)*exp(-2*zeta_d);
    A2=0.5+zeta_d^(-1)*exp(-2*zeta_d);

    Bw_div_Bw0=0.5*(((A1+1)+(A2-1)*tanh(20*(OMEGA-0.3)))  + (2*A1-A2-1)*exp(-150*(OMEGA-0.25)^2));
    bw44=Bw0*Bw_div_Bw0;
