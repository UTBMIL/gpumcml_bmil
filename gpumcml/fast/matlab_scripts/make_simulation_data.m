clear all; close all; clc

musp_vs = 3.8809 * 10;
mua_es = 3.7836;
% gammas = linspace(0.9,1.9,10);
gammas = 1.9;
gs = 0.9;
%%


for g = gs
    RunMCw1gamma1g_original(musp_vs,g,mua_es)
end  
%%
close all;


for g = gs
	for musp_v_cm = musp_vs
		for mua = mua_es
			if isfile(['Test/SFDR/SFDR_mu_' num2str(musp_v_cm) '_g_' num2str(g) '_mua_' num2str(mua) '.mat'])
                continue
            end


            data = load(['Test/Simulation_musp_' num2str(musp_v_cm) '_g_' num2str(g) '_mua_' num2str(mua) '.mat']);

            fx = [0 .01 .025 .05:.05:1.8];
%             fx = [0.0:.05:1];


            r_log = [data.dr:data.dr:data.dr*data.Ndr] * 10;
            R_log = data.MCoutput.refl_r * 1/100;


            SFDR_1Y = ht(R_log,r_log,fx*2*pi);
            
            fprintf("done")


            save(['Test/SFDR/SFDR_mu_' num2str(musp_v_cm) '_g_' num2str(g) '_mua_' num2str(mua) '.mat'],'SFDR_1Y');
		end
	end
end

