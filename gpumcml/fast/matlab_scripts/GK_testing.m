close all; clear all; clc

angles = linspace(0,pi,20000);
u = cos(angles);

g1_goal = 0.93;
gamma_goal = 2.08;

gs = linspace(0.001,0.999,100);
% as = logspace(log10(0.1),log10(0.9),50);
% as = 0.5;
as = linspace(-0.5,11,100)

allgs = zeros(1,length(gs)*length(as));
allas = zeros(1,length(gs)*length(as));
allg1s = zeros(1,length(gs)*length(as));
allgammas = zeros(1,length(gs)*length(as));

i = 1;

for g = gs
    for a = as

    K = 1/pi * a * g * (1-g^2)^(2*a)/((1 + g)^(2*a) - (1 - g)^(2*a));

    pGK = K*(1 + g^2 - 2*g*u).^(-(a + 1));

%     g1 = -2 * pi * trapz(u, u.*pGK);
    
    L = ((1+g)^(2*a)+(1-g)^(2*a))/((1+g)^(2*a) - (1-g)^(2*a));
    g1 = (2*g*a*L - (1 + g^2))/(2*g*(a-1));

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

save('a_interpolant','F2')
save('g_interpolant','F')

%%
gammas = [1.03,0.99,0.97,1.03,0.99,0.97,1.8,1.44,1.24,1.8,1.44,1.24,2.08,2.14,2.17,2.08,2.14,2.17];
musp_vs = [3.6,2,1.11,5.39,3,1.67,2.26,2,1.54,3.4,3,2.31,2.16,2,1.87,3.25,3,2.8] * 10; %cm^-1
g1 = [.14, .1, .07, .14, .1, .07, .58, .42, .3, .58, .42, .3, .93, .93, .92, .93, .93, .92];

hold all;

for i = 1:length(gammas)
    gam = gammas(i);
    g = g1(i);
    scatter(g,gam)
end

ylim([0 3])
    