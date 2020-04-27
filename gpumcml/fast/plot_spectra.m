close all; clc

musp_vs = 1 * 10; %cm^-1
gs = [.3];

mua_v = 0.01
% gammas = linspace(0.95,1.27,3);
gammas = 0.95;
% gammas = gammas(1:6);


% data = load('Phantoms_Ind.mat');

fx = [.01 .025 .05:.05:1.8];

for gam = gammas
    for g = gs
        if gam > 1 + g
            continue
        end
        for mua_e = mua_v
            for musp_v_cm = musp_vs

                R_MCM_data = load(['Test/SFDR/SFDR_mu_' num2str(musp_v_cm) '_gamma_' num2str(gam) '_g_' num2str(g) '_mua_' num2str(mua_e) '.mat']);
%                 R_MCM_data = load(['Test_12_1/SFDR/SFDR_mu_' num2str(musp_v_cm) '_gamma_' num2str(gam) '_g_' num2str(g) '.mat']);

                X = R_MCM_data.SFDR_1Y;
%                 mycolor = vals2colormap(gam, 'jet', [min(gammas), max(gammas)]);
%                 mycolor = 'b'
%                 semilogy(fx,X,'color',mycolor)
%                 figure()
                semilogy(fx,X)
                hold all;
                
            end
        end
    end
end

xlabel('f')
ylabel('R')