%% Main 
clear all; clc; close all

% Global varialbes


global env
global log

% Create rocket class

roro = rocket(init_rocket());% creates class with the initial values
%%
motor_init( roro ); %loads rocket motor
%%
% Initilize Environmental variables 
% optional argument: Elevation(m) Temperature(C)and Pressure(Pa)
env = environement(350, 15, 96000, roro );

%% Phase: Accent
tend=30;
[t, state] = accent_calc(roro,tend);
%%
figure(1);
plot(t,state(:,3))
xlabel('Time(s)')
ylabel('Height (m)')
% 
figure(2);
plot3(state(:,1),state(:,2),state(:,3))
xlabel('x(m)')
ylabel('y (m)')
zlabel('Height (m)')
axis([-500 500 -500 500 0 800])
h_max=max(state(:,3))


%%
extract_data ( state,t);

%% Debugging plots
% figure(3)
% 
% plot(log(:,10),log(:,2))
% 
% xlabel('Time')
% ylabel('Value1, Value2')
% %axis([0 20 0.0 1])
% % 
figure
hold on
plot(log(:,12),log(:,13))
xlabel('Time(s)')
ylabel('Acceleration')
legend('Test Flight','Simulation')
%t2 = log(:,12);
% roll_acel2 = log(:,13);
% indStart=find(t2>4,1)
% indEnd=find(t2>7,1)
% plot(t2(indStart:indEnd),roll_acel2(indStart:indEnd))
% hold on

%% Plot flight and stability data
plotData(log, roro);

