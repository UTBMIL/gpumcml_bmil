close all; clc

musp_vs = 1 * 10; %cm^-1
gs = [.9];

mua_v = 0.01

% gammas = 0.95;

fx = [.01 .025 .05:.05:1.8];


for g = gs
    for mua_e = mua_v
        for musp_v_cm = musp_vs
            R_MCM_data = load(['Test/SFDR/SFDR_mu_' num2str(musp_v_cm) '_gamma_' num2str(gam) '_g_' num2str(g) '_mua_' num2str(mua_e) '.mat']);

            X = R_MCM_data.SFDR_1Y;

            semilogy(fx,X)
            hold all;
        end
    end
end


xlabel('f')
ylabel('R')