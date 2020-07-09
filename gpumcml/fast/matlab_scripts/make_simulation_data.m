clear all; close all; clc

mua_es = linspace(0.01,5,15);
mua_d = 0;
thi = 0;

musp_vs = linspace(1.0,6,40) * 10;
gammas = linspace(0.95,2.3,20);
gs = [0.9];
% 
mua_es = mua_es(1:3:end);
musp_vs = musp_vs(1:3:end);
gammas = gammas(1:3:end);


for gam = gammas
    for g = gs     
        for mua_e = mua_es
            musp_v_cm = musp_vs;
            
            if gam < 1 + 0.6 * g
                continue
            end
            if gam > (exp(1))^(log(3)*g)
                continue
            end

            RunMCw1gamma1g_GK(gam,musp_v_cm,g,mua_e);
        end
    end  
end
%%
close all;

for mua_e = mua_es
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
