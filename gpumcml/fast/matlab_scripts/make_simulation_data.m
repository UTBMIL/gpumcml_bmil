clear all; close all; clc

mua_e = 0.01;
mua_d = 0;
thi = 0;

gs = [.3];

musp_vs = 3*10;

%%


for g = gs

    musp_v_cm = musp_vs;

    RunMCw1gamma1g_original(musp_v_cm,g)
end  
%%
close all;


for mua_e = 0.01
    for g = gs
        for musp_v_cm = musp_vs
            data = load(['Test/Simulation_musp_' num2str(musp_v_cm) '_g_' num2str(g) '_mua_' num2str(mua_e) '.mat']);

            fx = [.01 .025 .05:.05:1.8];


            r_log = [data.dr:data.dr:data.dr*data.Ndr] * 10;
            R_log = data.MCoutput.refl_r * 1/100;


            SFDR_1Y = ht(R_log,r_log,fx*2*pi);


            save(['Test/SFDR/SFDR_mu_' num2str(musp_v_cm) '_g_' num2str(g) '_mua_' num2str(mua_e) '.mat'],'SFDR_1Y');
        end
    end
end

