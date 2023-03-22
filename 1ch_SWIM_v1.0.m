clc;
%% modelling Standalone Wireless Impedance Matching (SWIM) for L-matching 

%input impedance of the loop with distribution caps
R=60;%loop radius in mm
d=1.0;%wire diameter in mm
b=3;%number breaks in coil


%freq sweep
freq = 400*10^6;

% s11req=0.8;

%load impedance 
ZL1=impedance(R,d,freq,b)

% system impedance
Z0 = 50;

%starting values for the capacitors
Par0 = 10^-12*[1;10]; %both caps start at 1pF(can be adjusted)

%local minima search algorithm
%options = optimset('MaxIter',256,'PlotFcns',@optimplotfval); 
[Opt_Par,fval] = fminsearch(@(Par1)SWIM1(Par1,Z0,freq,ZL1),Par0);

%capalues in pF
Opt_capvalues = Opt_Par/10^-12
% grid on;

% freq sweep for the optimal value caps - impedance matching
k = [10:1:500]*1e6;
[RL_opt,gamma1]=SWIM1(Opt_Par,Z0,k,ZL1);
returnloss = 20*log10(RL_opt);
figure(2); 
plot(k,returnloss);
hold on;
grid on;
figure(3);
f=smithplot(k,gamma1,'GridType','ZY');



%% Function to calaculate return loss/S11 of the coil

function [RL1,gamma1] = SWIM1(Par1,Z0,freq,ZL1)
Cp1 = Par1(1);
Cs1 = Par1(2);

omega=2*pi*freq;
Yp1 = 1j*omega*Cp1;
Zs1 = 1./(1j*omega*Cs1);

YL1 = ZL1.^-1;

%shunt capacitor - tuning
Y1 = Yp1+YL1;
Z1 = Y1.^-1;

%series capacitor - matching
Zin1 =(Z1+Zs1);

%return loss - s11
S11 = (Zin1-Z0)./(Zin1+Z0);

RL1=abs(S11);
gamma1=z2gamma(Zin1,Z0);
end
%% Function to calculate the input impedance of coil based on user inputs

function ZL = impedance(R,d,freq,b)
%necessary const
Aw=d/2;
circ = 2*pi*R;
lbreak = circ/b;
rhocop = 1.68*10^-8;
omega=2*pi*freq;

muo=4*pi*10^-7;
mur=0.999991;
mueff= muo*mur;

%inductance of the complete loop without break
L=R*mueff*[log((8*R)/Aw)-2]*10^-3;

%total capacitance required to resonate at freq
Ctot = (L*omega^2)^-1;

%cap at each break - all caps in series
Cbreak = b*Ctot;

%impedance of each wire piece
    %inductance of wire break
    y=2*lbreak;%const
    x = sqrt(1+(d/y)^2);%const
    Lwire = y*((log((y/d)*(1+x)))-x+(mur/4)+(d/y))*10^-10;%inductance of cut wire
    
    %effective diameter for AC resistance calculation
    skd = sqrt((rhocop)/(pi*freq*mueff));%skin depth of conductor
    Aeff = skd*pi*d;

    Xwire = 1j*omega*Lwire;%inductance
    Rwire = ((rhocop*lbreak)/Aeff);%resistance
Zwire = 1.1 + Rwire + Xwire;%added solder+pcb pad resistance(can be adjusted)

%impedance of capacitors
Zcb = 0.2+1/(1j*omega*Ctot);%added: resistance of generic 2828 capacitor(can be adjusted)

%total input impedance of coil
ZL = (b*Zwire)+Zcb;

end