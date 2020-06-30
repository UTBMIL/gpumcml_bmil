clear all; close all; clc

mua_e = 0.01;
mua_d = 0;
thi = 0;

musp_vs = linspace(1.0,6,20) * 10;
gammas = linspace(0.95,2.3,15);
gs = [0.1 0.5 0.9];

for gam = gammas
    for g = gs        
        musp_v_cm = musp_vs;
    
        RunMCw1gamma1g_GK(gam,musp_v_cm,g)
    end  
end
%%
close all;

for mua_e = 0.01
    for gam = gammas
        for g = gs
            for musp_v_cm = musp_vs
                if isfile(['Test/SFDR/SFDR_mu_' num2str(musp_v_cm) '_gamma_' num2str(gam) '_g_' num2str(g) '_mua_' num2str(mua_e) '.mat'])
                    continue
                end
                data = load(['Test/Simulation_gamma' num2str(gam) '_musp_' num2str(musp_v_cm) '_g_' num2str(g) '_mua_' num2str(mua_e) '.mat']);

                fx = [0 .01 .025 .05:.05:1.8];


                r_log = [data.dr:data.dr:data.dr*data.Ndr] * 10;
                R_log = data.MCoutput.refl_r * 1/100;


                SFDR_1Y = ht(R_log,r_log,fx*2*pi);

                save(['Test/SFDR/SFDR_mu_' num2str(musp_v_cm) '_gamma_' num2str(gam) '_g_' num2str(g) '_mua_' num2str(mua_e) '.mat'],'SFDR_1Y');
            end
        end
    end
end
