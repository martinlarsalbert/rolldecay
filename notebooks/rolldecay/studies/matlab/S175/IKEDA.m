clear global
global vcg B d A bBK R g OG Ho ra visc Cb L%constants only!!

 %constants only!!


visc = 1.15*10^-6;             % [m2/s], kinematic viscosity
Cb   = 0.58;                   % Block coeff
L    = 175;                    % Length
vcg  =   9.52;                 % roll axis (vertical centre of gravity) [m]
B    =   25.40;                % Breadth of hull [m]
d    =   9.5;                  % Draught of hull [m]
A    =   0.95*B*d;             % Area of cross section of hull [m2]
bBK  =   0.4;                  % breadth of Bilge keel [m] !!(=height???)
R    =   3;                    % Bilge Radis
g    =   9.81;

OG = vcg-d;                 % distance from roll axis to still water level
Ho = B/(2*d);               % half breadth to draft ratio
ra   = 1025;                % density of water

%locals
LBK  = L/4;                % Approx
disp = L*B*d*Cb;           % Displacement
ND_factor = sqrt(B/(2*g))/(ra*disp*(B^2));   % Nondimensiolizing factor of B44
% variables!!

T=20; wE   = 2*pi*1/T;        % circular frequency
fi_a =   5*pi/180;          % roll amplitude !!rad??
%V    =   5;                 % Speed

Wave=[];
Bilgekeel=[];
Friction=[];
Lift=[];

Vvec=[1:17];
for V=Vvec
% components
% wave
[bw44] = Bw_S175(wE,V)

%bilge keel
[Bp44BK_N0,Bp44BK_H0,B44BK_L,B44BKW0] = BilgeKeel(wE,fi_a,V);

B44BK_N0 = Bp44BK_N0 * LBK%
B44BK_H0 = Bp44BK_H0 * LBK%
B44BK_L  = B44BK_L
% B44BKW0 = B44BKW0*dim...
B44_BK = B44BK_N0+B44BK_H0+B44BK_L

% Frictional
B44F = Frictional(wE,fi_a,V)

% Hull lift
[B44L] = HullLift(V)
% hold on
% plot(V,bw44,'*',V,B44_BK,'.',V,B44F,'x',V,B44L,'o')
% hold on

Wave=[Wave bw44];
Bilgekeel=[Bilgekeel B44_BK];
Friction=[Friction B44F];
Lift=[Lift B44L];
end



Total=[Wave; Friction; Lift; Bilgekeel]'*ND_factor;
VVEC=[Vvec; Vvec; Vvec; Vvec]'
FnVEC=VVEC./sqrt(g*L);
h=area(FnVEC,Total)
set(h(1),'FaceColor',[0 0 0.3])
set(h(2),'FaceColor',[0 0 0.5])
set(h(3),'FaceColor',[0 0 0.7])
set(h(4),'FaceColor',[0 0 1])
set(h,'LineStyle','-','LineWidth',2) % Set all to same value
legend(['Wave'],['Friction'],['Lift'],['Bilge Keel'])

% gtext('Wave')
% gtext('Friction')
% gtext('Lift')
% gtext('Bilge Keel')
