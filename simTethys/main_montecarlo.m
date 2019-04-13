%% Main 
%clear all; clc;

% Global varialbes
global var
global env
%global log
%monte_carlo = [];

for (i=1:10)
%% Variation of parameters 
var.cn = normrnd(1,0.05);
var.ca = normrnd(1,0.1);
var.mass =1;% normrnd(1,0.05);
var.Xcp = normrnd(1,0.05);
var.Wx = normrnd(0,3);
var.Wy = normrnd(0,3);

% Create rocket class

roro = rocket(init_rocket());% creates class with the initial values
motor_init( roro ); %loads rocket motor
% Initilize Environmental variables 
% optional argument: Elevation(m) Temperature(C)and Pressure(Pa)
env = environement(1400, 25, 86000, roro );


i
%% Phase: Accent
tend=30;
[t, state] = accent_calc(roro,tend);
%%
% figure(1);
% plot(t,state(:,3))
% xlabel('Time(s)')
% ylabel('Height (m)')
% % 
figure(2);
plot3(state(:,1),state(:,2),state(:,3))
xlabel('x(m)')
ylabel('y (m)')
zlabel('Height (m)')
axis([-500 500 -500 500 0 800])
monte_carlo = [monte_carlo;state(end,1:3)];
h_max=max(state(:,3))

end
%%
%h_max=max(state(:,3))
Nx = [mean(monte_carlo(:,1)),std(monte_carlo(:,1))]
Ny = [mean(monte_carlo(:,2)),std(monte_carlo(:,2))]
Nz = [mean(monte_carlo(:,3)),std(monte_carlo(:,3))]
%%
figure(2);
%A = load('state','-mat');
%A = A.state;
plot3(state(:,1),state(:,2),state(:,3))
xlabel('x(m)')
ylabel('y (m)')
zlabel('Height (m)')
axis([-500 500 -500 500 0 3300])

hold on 
length =length(monte_carlo);
for (i=1:length)
plot3(monte_carlo(i,1),monte_carlo(i,2),monte_carlo(i,3),'*')
end
%%

%extract_data ( state,t);


%% Plot flight and stability data
%plotData(log, roro);

%% Plots xy and height varience 
x=linspace(Nz(1)-80,Nz(1)+80,201);
y=1/sqrt(2*pi*Nz(2))*exp(-(x-Nz(1)).^2./(2*Nz(2)));
 plot(x,y);
 xlabel('Height[m]');
 ylabel('P');

 %%
 x=linspace(-100+Nx(1),100+Nx(1),101);
 y=linspace(-100+Ny(1),100+Ny(1),101);
y1=1/sqrt(2*pi*Nx(2))*exp(-(x-Nx(1)).^2./(2*Nx(2)));
y2=1/sqrt(2*pi*Ny(2))*exp(-(y-Ny(1)).^2./(2*Ny(2)));
g=[];
for(i=1:101)
    g = [g ; y1(i)*y2];
end
 surf(g);
 xlabel('Distance[m]');
 ylabel('Distance[m]');
 zlabel('P');