close all; clear all; clc



g1_goal = 0.93;
gamma_goal = 2.08;

ptsintab = 50;

gs = linspace(0.001,0.999,ptsintab);
% as = logspace(log10(0.1),log10(0.9),50);
% as = 0.5;
as = linspace(-0.5,11,ptsintab);

allgs = zeros(1,length(gs)*length(as));
allas = zeros(1,length(gs)*length(as));
allg1s = zeros(1,length(gs)*length(as));
allgammas = zeros(1,length(gs)*length(as));

i = 1;

for g = gs
    for a = as

    [g1, gamma] = forward_GK_parameters(g,a);
    
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
F = scatteredInterpolant(allgammas',allg1s',allgs','nearest');
F2 = scatteredInterpolant(allgammas',allg1s',allas','nearest');
F(gamma_goal,g1_goal)
F2(gamma_goal,g1_goal)

save('a_interpolant','F2')
save('g_interpolant','F')

%%
gammas = [1.03,0.99,0.97,1.03,0.99,0.97,1.8,1.44,1.24,1.8,1.44,1.24,2.08,2.14,2.17,2.08,2.14,2.17];
musp_vs = [3.6,2,1.11,5.39,3,1.67,2.26,2,1.54,3.4,3,2.31,2.16,2,1.87,3.25,3,2.8] * 10; %cm^-1
g1s = [.14, .1, .07, .14, .1, .07, .58, .42, .3, .58, .42, .3, .93, .93, .92, .93, .93, .92];

hold all;

for i = 1:length(gammas)
    gam = gammas(i);
    g = g1s(i);
    scatter(g,gam)
end

ylim([0 3])

%%%Test it

gamma_guess = [];
g1_guess = [];
true_gamma = [];
ture_g1 = [];

interpolant_data = load('g_interpolant')
gmap = interpolant_data.F;
interpolant_data_2 = load('a_interpolant')
amap = interpolant_data_2.F2;

for i = 1:length(gammas)
    gamma_goal = gammas(i);
    g1_goal = g1s(i);
    
%     if gamma_goal < 1 + g1_goal
%         continue
%     end
%     
    
    g = gmap(gamma_goal,g1_goal);
    a = amap(gamma_goal,g1_goal);

    [g1, gamma] = forward_GK_parameters(g,a);
    
    gamma_guess(i) = gamma;
    g1_guess(i) = g1_goal;
    true_gamma(i) = gamma_goal;
    true_g1(i) = g1_goal;
    
    
    
    
end

figure()
scatter(true_gamma,gamma_guess)
hold all;
plot(true_gamma,true_gamma)

xlabel('desired gamma')
ylabel('produced gamma')

figure()
scatter(true_g1,g1_guess)
hold all;
plot(true_g1,true_g1)

xlabel('desired g1')
ylabel('produced g1')

    