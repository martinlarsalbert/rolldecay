clear global
global vcg B d A bBK R g OG Ho ra visc Cb L ScaleF C_mid%constants only!!

 %constants only!!

ScaleF =  1/29.565;                  % Scale Factor [-]
visc =   1.15*10^-6;                  % [m2/s], kinematic viscosity
Cb   =   0.61;                        % Block coeff
L    =   220*ScaleF;                  % Length
vcg  =   14.4*ScaleF;                 % roll axis (vertical centre of gravity) [m]
vcg  =   14.9*ScaleF;                 % roll axis (vertical centre of gravity) [m]
B    =   32.26*ScaleF;                % Breadth of hull [m]
d    =   9.5*ScaleF;                  % Draught of hull [m]
A    =   0.93*B*d;                    % Area of cross section of hull [m2]
bBK  =   0.8*ScaleF;                  % breadth of Bilge keel [m] !!(=height???)
R    =   5*ScaleF;                    % Bilge Radis
g    =   9.81;
C_mid=   0.93;

OG = -1*(vcg-d)*1;                    % distance from roll axis to still water level
Ho = B/(2*d);                  % half breadth to draft ratio
ra   = 1025;                   % density of water

%locals
LBK  = L/8;                    % Approx
disp = L*B*d*Cb;               % Displacement

% variables!!

for fi_a = [2 4 6 8 10 12]*pi/180

T=27.6*sqrt(ScaleF); wE   = 2*pi*1/T;        % circular frequency
%T=23*sqrt(ScaleF); wE   = 2*pi*1/T;        % circular frequency
%fi_a =   2*pi/180;            % roll amplitude !!rad??
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

Vvec=[0:0.05:20*1.852/3.6*sqrt(ScaleF)];
for V=Vvec
% components
% wave
[bw44] = Bw_4444(wE,V);

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
[B44L] = HullLift(V)
% hold on
% plot(V,bw44,'*',V,B44_BK,'.',V,B44F,'x',V,B44L,'o')
% hold on

[B44E] = Eddy(wE,fi_a,V)

Wave=[Wave bw44]*1;
Bilgekeel=[Bilgekeel B44_BK]*1;
%Bilgekeel=[Bilgekeel B44_BK]*1;
Friction=[Friction B44F]*1;
Lift=[Lift B44L]*1;
EDDY=[EDDY B44E]

B44BKW0_vec = [B44BKW0_vec B44BKW0];
B44BK_N0vec = [B44BK_N0vec B44BK_N0];
B44BK_H0vec = [B44BK_H0vec B44BK_H0];
B44BK_Lvec  = [B44BK_Lvec B44BK_L];
end

 fontsize=20;
figure(5)
tot=[Wave+Friction+EDDY+Lift+Bilgekeel]'*ND_factor
vvv=Vvec*3.6/1.852/sqrt(ScaleF);
hold on
subplot(1,2,1), plot(vvv,tot,'Color',[1-fi_a*180/pi/10 1-fi_a*180/pi/10 1-fi_a*180/pi/10],'linewidth',2),  fontsize=20, ,set(gca,'Fontsize',fontsize) ;
box on
end

%
% Total=[Wave; Friction; EDDY; Lift; Bilgekeel]'*ND_factor;
% VVEC=[Vvec; Vvec; Vvec; Vvec; Vvec]'
% FnVEC=VVEC./sqrt(g*L);
% hold on,
% fontsize=14;
% subplot(1,1,1); h=area(FnVEC,Total), set(gca,'Fontsize',fontsize) ;
% hold on
% set(h(1),'FaceColor',[0 0.6  0.5 ])
% set(h(2),'FaceColor',[0 0.7  0.3 ])
% set(h(3),'FaceColor',[0 0.8  0.2 ])
% set(h(4),'FaceColor',[0 0.9  0 ])
% set(h(5),'FaceColor',[0 1  0 ])
% %
% % set(h(1),'FaceColor',[0 0 0.5   ])
% % set(h(2),'FaceColor',[0 0 0.6   ])
% % set(h(3),'FaceColor',[0 0 0.7   ])
% % set(h(4),'FaceColor',[0 0 0.85   ])
% % set(h(5),'FaceColor',[0 0 1   ])
%
% % set(h(1),'FaceColor',[0.5 0 0 ])
% % set(h(2),'FaceColor',[0.6 0 0 ])
% % set(h(3),'FaceColor',[0.7 0 0 ])
% % set(h(4),'FaceColor',[0.85 0 0 ])
% % set(h(5),'FaceColor',[1 0 0 ])
%
% set(h,'LineStyle','-','LineWidth',2) % Set all to same value
%
% %legend(['Wave(\omega_0,V)'],['Friction(\omega_0,\phi_a,V)'],['Eddy(\omega_0,\phi_a,V)'],['Lift(V)'],['Bilgekeel(\omega_0,\phi_n,V)'])
% xlabel('Fn [-]')
% ylabel('\zeta_e _2_\circ [-]')
% title(['Faust, T_0; ',num2str(T),'s, GM; ',num2str(16*ScaleF-vcg),'m,  \phi_a;',num2str(fi_a*180/pi),'\circ'])
% axis([0 max(max(FnVEC)) 0 0.08])
%
% % gtext('Wave(\omega_E,V)','Fontsize',fontsize) ;
% % gtext('Friction(\omega_E,\phi_a,V)','Fontsize',fontsize);
% % gtext('Eddy(\omega_E,\phi_a,V)','Fontsize',fontsize);
% % gtext('Lift(V)','Fontsize',fontsize)
% % gtext('Bilge Keel(\omega_E,\phi_a,V)','Fontsize',fontsize);
%
%
%
% % gtext('Wave(\omega_E,V)','Fontsize',fontsize) ;
% % gtext('Friction(\omega_E,\phi_a,V)','Fontsize',fontsize);
% % gtext('Lift(V)','Fontsize',fontsize)
% % gtext('Bilge Keel(\omega_E,\phi_a,V)','Fontsize',fontsize);
%
% %legend(['Wave(\omega_E,V)'],['Friction(\omega_E,\phi_a,V)'],['Lift(V)'],['Bilge Keel(\omega_E,\phi_a,V)'])
% % figure(2)
% % fontsize=14;
% % subplot(5,1,4), area(Vvec,Wave*ND_factor),title('Wave(\omega_E,V)')
% % subplot(5,1,3), area(Vvec,EDDY*ND_factor),title('Eddy(\omega_E,\phi_a,V)')
% % subplot(5,1,2), area(Vvec,Friction*ND_factor),title('Friction (\omega_E,\phi_a,V)')
% % subplot(5,1,1), area(Vvec,Lift*ND_factor),title('Lift(V)')
% %
% % subplot(5,1,5), area(Vvec,[B44BK_N0vec; B44BK_H0vec; B44BK_Lvec]'*ND_factor),title('Bilgekeel(\omega_E,\phi_a,V)')
% % xlabel('speed [m/s]')
% % legend(['BK_N_0'],['BK_H_0'],['BK_L'])
%
