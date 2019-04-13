clc; clear;

w = length(0:0.5:5);
alphatab = [0:0.5:5];

v0tab= [0:10:250];
h= length(v0tab);
Cn = zeros(h,w);
Xcppos= zeros(w,1);
%% CP  calculator from openrocket
%for i=1:h
L = 2.646; %characteristic length
rho =  1.225; % density 
mu =  1.7894e-5;  % dynamic viscosity 
C = 340.3; %speed of sound dry air 15C sea level
v0 = v0tab(1);   %ms-1 characteristic velocity
M = v0/C;
Re  = rho*v0*L/mu;

% correction for 
beta = sqrt( 1 - M^2); % M <1

% Rocket dimentions 
L_cone = 0.61;
L_cyl = L - L_cone;
D_cyl = 0.158;
R_cyl = D_cyl/2;

%A_ref
A_ref = pi*R_cyl^2;

F_ratio = L / D_cyl;


%%
R_ogive = (L_cone^2+ D_cyl^2/4)/D_cyl;
%A_wet

fun = @(x) 2*pi*(sqrt(R_ogive^2 - power((L_cone - x),2))+R_cyl-R_ogive);

A_wet =  integral(fun, 0, L_cone);

A_wet = A_wet + 2*pi*R_cyl*L_cyl;

% Cone Vol

fun2 = @(x) pi*(power((sqrt(R_ogive^2 - power((L_cone - x),2))+R_cyl-R_ogive),2));
cone.vol =  integral(fun2, 0, L_cone);

%A_plan
temp_theta = atan(L_cone/(R_ogive-R_cyl));

cone.A_plan = 2*(R_ogive^2*temp_theta/2-((R_ogive-R_cyl)*L_cone)/2);

cyl.A_plan = D_cyl* L_cyl;
%Fin Geometry

fin.n=3;
fin.sweep = deg2rad(45);
fin.h = 11.5e-2;
fin.topchord = 11.5e-2;
fin.basechord = 21e-2;
fin.t = 1e-2;
fin.a_ref = fin.n*fin.h*fin.t;
fin.area = (fin.topchord+fin.basechord)/2*fin.h;
fin.a_wet = fin.n*2*fin.area;
fin.c = (fin.topchord+fin.basechord)/2;
fin.X_b =  L - fin.basechord; % fin location

% mid chord sweep

x1 = fin.h*tan(fin.sweep);

x2 = x1 + fin.topchord - fin.basechord;

fin.sweepc = atan2((fin.basechord/2 + (x2-fin.topchord/2)),fin.h);

%clear temp fun fun2

%% Center of presure
%for j=1:w
alpha =deg2rad(alphatab(1));

%% Cone 
% Cn_alpha 
if (alpha ==0)
    alpha = 0.00001,
end
K=1.1;
cone.Cn_correction = K * cone.A_plan/A_ref*sin(alpha)^2;
cone.Cn_alpha = 2* (A_ref/A_ref)*sin(alpha)/ alpha + cone.Cn_correction/alpha;

%% cylinder 
% Cn_alpha

cyl.Cn_correction = K * cyl.A_plan/A_ref*sin(alpha)^2;

cyl.Cn_alpha =  cyl.Cn_correction/alpha;
%% Fins 


fin.Cn1_alpha = ((2*pi*fin.h^2)/ A_ref)/(1 + sqrt(1 + (beta*fin.h^2/(fin.area*cos(fin.sweepc)))^2));

% N fins corrected for body interference n >= 3
fin.Cn_alpha = (1 + (R_cyl)/(R_cyl+ fin.h))*(fin.Cn1_alpha * fin.n/2*1);

%% CoP location
% Cone

cone.Xcp = (L_cone*(A_ref)-cone.vol)/A_ref

% cyl

cyl.Xcp = L_cone + L_cyl/2

%  Fins 
% at 25% mac
Xt = fin.h/tan(fin.sweep);
fin.Xcp = fin.X_b + (Xt/3*(fin.basechord +  2*fin.topchord) + 1/6*(fin.basechord+fin.topchord)^2)/(fin.basechord+fin.topchord)


Xcp = (fin.Cn_alpha*fin.Xcp + cone.Cn_alpha*cone.Xcp +  cyl.Xcp*cyl.Cn_alpha)/(fin.Cn_alpha+cone.Cn_alpha+cyl.Cn_alpha)
%% Roll damping 
% omega = deg2rad(140);
% Cn_alpha0 = 2*pi/beta; % from potential flow over a thin foil. 
% 
% temp = (fin.basechord+fin.topchord)*R_cyl^2*fin.h/2 + (fin.basechord+2*fin.topchord)*R_cyl*fin.h^2/3  + (fin.basechord+3*fin.topchord)*fin.h^3/12; 
% Cld = fin.n*Cn_alpha0/(A_ref*v0*D_cyl) * omega * temp;


%% Cn_alpha
Cn_alpha = fin.Cn_alpha + cyl.Cn_alpha + cone.Cn_alpha;

F_n = 0.5* v0^2* rho* A_ref * Cn_alpha*alpha;

% Cn(i,j) = Cn_alpha*alpha;
% Xcppos(j) = Xcp; 
% %end
% %end
% 
% surf(alphatab',v0tab',Cn)
% xlabel('alpha (deg)')
% ylabel('V0 (m/s)')
% zlabel('Cn')
% 
% %%
% 
% plot(alphatab,Xcppos)
% xlabel('alpha (deg)');
% ylabel('Xcp (m)');

