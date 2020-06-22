clear all; close all; clc

% mua_e = linspace(0.01,5,10);
mua_e = linspace(0.01,5,29);
mua_d = 0;
thi = 0;

gs = [.1, .3, .5, 0.9];
% gs = 0.9;

% musp_vs = linspace(6.5,31.1,10);
% musp_vs = linspace(35.6,60,41);
musp_vs = linspace(1.0,6,50) * 10; %cm^-1


%%


for g = gs
    RunMCw1gamma1g_original(musp_vs,g,mua_e)
end  
%%
close all;


for g = gs
	for musp_v_cm = musp_vs
		for mua = mua_e
			if isfile(['Test/SFDR/SFDR_mu_' num2str(musp_v_cm) '_g_' num2str(g) '_mua_' num2str(mua_e) '.mat'])
                continue
            end


            data = load(['Test_HG_Train_meters/Simulation_musp_' num2str(musp_v_cm) '_g_' num2str(g) '_mua_' num2str(mua) '.mat']);

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

