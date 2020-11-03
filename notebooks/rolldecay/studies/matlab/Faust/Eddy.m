function [B44E] = Eddy(wE,fi_a,V)
global d R OG ra L ScaleF

%ITTC but Journe gamma
%%Data_H4444

%% section data (Lewis coefficients etc)

% d-draught; x-long locations; As-wet section areas; Ts-section draught; bwl-water line beam
% H-beam/draught-ratio (=bwl./Ts); sigma-section area coefficient (= As./(bwl.*Ts))
% C,a0,a1,a3-Lewis coefficients

x= [ -4.0000
    0
    2.3750
    4.7500
    7.1250
    23.7500
    38.0000
    47.5000
    57.0000
    66.5000
    80.7500
    109.5500
    123.8000
    133.3000
    142.8000
    161.8000
    171.3000
    185.5500
    195.0500
    204.5500
    209.3000
    214.0500
    218.8000
    223.3000
    223.8000]*ScaleF;

%       H     sigma     C           a0      a1       a3        As           Ts      bwl
M0 = [Inf       Inf       NaN       NaN       NaN       NaN    0.0000         0    0.0050
    30.4015    0.5543    3.9318    3.2037    0.9065    0.0341    2.8187    0.4090   12.4342
    25.6688    0.5846    3.9314    4.3603    0.8848    0.0343    6.3790    0.6520   16.7361
    3.0445    0.0850    3.1464    5.5899    0.3057    0.4764   11.0780    6.5440   19.9235
    3.0119    0.1171    3.1838    6.4200    0.2931    0.4518   19.5248    7.4390   22.4056
    3.1737    0.3991    3.5335    9.8893    0.2819    0.2425  114.3117    9.5000   30.1504
    3.3618    0.6179    3.8005   11.5703    0.2795    0.1006  187.4684    9.5000   31.9376
    3.3944    0.7339    3.9388   12.4307    0.2664    0.0306  224.8109    9.5000   32.2464
    3.3958    0.8279    4.0505   13.1471    0.2521   -0.0253  253.7244    9.5000   32.2600
    3.3958    0.8908    4.1252   13.6751    0.2424   -0.0629  273.0054    9.5000   32.2600
    3.3958    0.9252    4.1661   13.9861    0.2370   -0.0837  283.5413    9.5000   32.2600
    3.3958    0.9252    4.1661   13.9861    0.2370   -0.0837  283.5413    9.5000   32.2600
    3.3958    0.9088    4.1467   13.8361    0.2396   -0.0738  278.5342    9.5000   32.2600
    3.3958    0.8737    4.1049   13.5269    0.2451   -0.0526  267.7703    9.5000   32.2600
    3.3780    0.8173    4.0380   13.0202    0.2514   -0.0190  249.1773    9.5000   32.0908
    3.0415    0.6975    3.8929   11.3634    0.2177    0.0537  191.4665    9.5000   28.8944
    2.6697    0.6505    3.8318   10.2252    0.1555    0.0846  156.7309    9.5000   25.3621
    1.8835    0.6084    3.7749    8.2813   -0.0334    0.1138  103.4239    9.5000   17.8934
    1.2693    0.6190    3.7987    7.0491   -0.2462    0.1015   70.9109    9.5000   12.0583
    0.6688    0.7541    3.9701    6.2449   -0.5063    0.0150   45.5152    9.5000    6.3533
    0.4086    1.0019    4.1553    6.2058   -0.6091   -0.0782   36.9437    9.5000    3.8815
    0.1705    2.0474    4.4652    7.0510   -0.6161   -0.2691   31.4898    9.4980    1.6193
    0       Inf       NaN       NaN       NaN       NaN   27.6311    8.7550         0
    0       Inf       NaN       NaN       NaN       NaN    6.8929    4.6800         0
    0       NaN       NaN       NaN       NaN       NaN         0    1.7000         0];

%x = x(4:22); M0 = M0(4:22,:);   %erasing nonsens sections

%x = x(4:22)*ScaleF; M0 = M0(4:22,:);   %erasing nonsens sections
for ii = [1:8]
    M0(ii,:)= M0(9,:)
end

for ii = [23:25]
    M0(ii,:)= M0(22,:)
end




H0 = M0(:,1)/2; sigma = M0(:,2); a1 = M0(:,5); a3 = M0(:,6); bwl = M0(:,9)*ScaleF; Ts=M0(:,8)*ScaleF;
%%
%%% Eddy


%i=10;
B44E0=0;

for i = 1:length(x)-1
    %for i = 4:18
    M    = bwl(i)/(2*(1+a1(i)+a3(i)));      %!!!!!! bwl eller B??

    fi1=0;
    fi2=0.5*acos(a1(i)*(1+a3(i)))/(4*a3(i));
    rmax_fi1 = M*sqrt(((1+a1(i))*sin(fi1)-a3(i)*sin(fi1))^2+((1-a1(i))*cos(fi1)-a3(i)*cos(fi1))^2);
    rmax_fi2 = M*sqrt(((1+a1(i))*sin(fi2)-a3(i)*sin(fi2))^2+((1-a1(i))*cos(fi2)-a3(i)*cos(fi2))^2);

    if rmax_fi2 > rmax_fi1
        fi = fi2;
    else
        fi = fi1;
    end

    B0 = -2*a3(i)*sin(5*fi)+a1(i)*(1-a3(i))*sin(3*fi)+((6+3*a1(i))*a3(i)^2+(3*a1(i)+a1(i)^2)*a3(i)+a1(i)^2)*sin(fi);
    A0 = -2*a3(i)*cos(5*fi)+a1(i)*(1-a3(i))*cos(3*fi)+((6-3*a1(i))*a3(i)^2+(a1(i)^2-3*a1(i))*a3(i)+a1(i)^2)*cos(fi);
    H = 1+a1(i)^2+9*a3(i)^2+2*a1(i)*(1-3*a3(i))*cos(2*fi)-6*a3(i)*cos(4*fi);
    %sigma_p=(sigma(i)-OG/d)/(1-OG/d)
    sigma_p=sigma(i)
    %H0_p=H0(i)/(1-OG/d);
    H0_p=bwl(i)/(2*Ts(i));

    f3=1+4*exp(-1.65*10^5*(1-sigma(i))^2);

    %gamma=sqrt(pi)*f3*(max(rmax_fi1,rmax_fi2)+2*M/H)*sqrt(B0^2*A0^2)/(2*d*(1-OG/d)*sqrt(H0_p*sigma_p)); %
    gamma=sqrt(pi)*f3*(max(rmax_fi1,rmax_fi2)+2*M/H*sqrt(B0^2*A0^2))/(2*Ts(i)*sqrt(H0(i)*(sigma_p+OG/Ts(i)))); %Journee

    f1= 0.5*(1+tanh(20*(sigma(i)-0.7)));
    f2=0.5*(1-cos(pi*sigma(i)))-1.5*(1-exp(-5*(1-sigma(i))))*(sin(pi*sigma(i)))^2;



    Cp= 0.5*(0.87*exp(-gamma)-4*exp(-0.187*gamma)+3);
    %Cp= 0.35*exp(-gamma)-2*exp(-0.187*gamma)+1.5;

    Cr=((1-f1*R/d)*(1-OG/d)+f2*(H0(i)-f1*R/d)^2)*Cp*(max(rmax_fi1,rmax_fi2)/d)^2
    %Cr=((1-f1*R/d)*(1-OG/d+f1*R/d)+f2*(H0(i)-f1*R/d)^2)*Cp*(max(rmax_fi1,rmax_fi2)/d)^2 %lagt till termen +f1*R/d i andra faktorn enl journe



    Bp44E0=4*ra*d^4*wE*fi_a*Cr/(3*pi);
    Bs44E0=Bp44E0*(x(i+1)-x(i));

    B44E0=B44E0+Bs44E0;
end

K=V/(0.04*wE*L);
B44E=B44E0*1/(1+K^2)


%BE0nd=B44E0*wE/(2*ra*disp*g*(16*ScaleF-vcg));
