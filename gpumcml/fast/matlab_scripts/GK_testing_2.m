close all; clear all; clc

interpolant_data = load('g_interpolant')
gmap = interpolant_data.F;
interpolant_data_2 = load('a_interpolant')
amap = interpolant_data_2.F2;

angles = linspace(0,pi,20000);
u = cos(angles);

g1_goal = 0.93;
gamma_goal = 2.08;

% a = .7025;
% g = 0.8844;

% a = 1/2;
% g = 0.9;

g = gmap(g1_goal,gamma_goal);
a = amap(g1_goal,gamma_goal);

K = 1/pi * a * g * (1-g^2)^(2*a)*((1 + g)^(2*a) - (1 - g)^(2*a))^(-1);

pGK = K*(1 + g^2 - 2*g*u).^(-(a + 1));

g1 = -2 * pi * trapz(u, u.*pGK)



g2 = 2*pi*trapz(angles, pGK.*sin(angles).*(1/2 * (3*(cos(angles)).^2 - 1)));

gamma = (1 - g2)/(1 - g1)
    
