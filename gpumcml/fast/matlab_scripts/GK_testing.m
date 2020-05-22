close all; clear all; clc

angles = linspace(0,pi,20000);
u = cos(angles);

g1_goal = 0.93;
gamma_goal = 2.08;

gs = linspace(0.01,0.9,100);
as = linspace(-0.9,4,100);

allgs = zeros(1,length(gs)*length(as));
allas = zeros(1,length(gs)*length(as));
allg1s = zeros(1,length(gs)*length(as));
allgammas = zeros(1,length(gs)*length(as));

i = 1;

for g = gs
    for a = as

    K = 1/pi * a * g * (1-g^2)^(2*a)*((1 + g)^(2*a) - (1 - g)^(2*a))^(-1);

    pGK = K*(1 + g^2 - 2*g*u).^(-(a + 1));

    g1 = -2 * pi * trapz(u, u.*pGK);
    
    

    g2 = 2*pi*trapz(angles, pGK.*sin(angles).*(1/2 * (3*(cos(angles)).^2 - 1)));

    gamma = (1 - g2)/(1 - g1);
    
    allgs(i) = g;
    allas(i) = a;
    allg1s(i) = g1;
    allgammas(i) = gamma;
    
    i = i + 1;
    end
end

scatter(allg1s, allgammas)
hold all;
plot(allg1s, allg1s + 1)

xlabel('g1')
ylabel('gamma')
%%
F = scatteredInterpolant(allgammas',allg1s',allgs');
F2 = scatteredInterpolant(allgammas',allg1s',allas');
F(gamma_goal,g1_goal)
F2(gamma_goal,g1_goal)

save('a_interpolant','F')
save('g_interpolant','F2')