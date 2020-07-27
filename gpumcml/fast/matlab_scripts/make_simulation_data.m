clear all; close all; clc

interpolant_data = load('g_interpolant')
gmap = interpolant_data.F;
interpolant_data_2 = load('a_interpolant')
amap = interpolant_data_2.F2;

musp_vs = 3.8809 * 10;
mua_es = 3.7836;

%gammas = 1.9;
gammas = linspace(0.9,1.9,10);

gs = 0.9;

for gamma = gammas
    for g1 = gs
        for mua_e = mua_es
            musp_v_cm = musp_vs;
            
            if gamma < 1 + 0.6 * g1
                continue
            end
            if gamma > (exp(1))^(log(3)*g1)
                continue
            end
            
            gGK = gmap(gamma,g1);
            aGK = amap(gamma,g1);
            [g, gam] = forward_GK_parameters(gGK,aGK);

            RunMCw1gamma1g_GK(gam,musp_v_cm,g,mua_e);
            RunMCw1gamma1g_original(gam,musp_v_cm,g,mua_e);
        end
    end  
end
%%
close all;
%for MHG

for mua_e = mua_es
    for gam = gammas
        for g = gs
            for musp_v_cm = musp_vs
                if isfile(['Test/SFDR/SFDR_mu_' num2str(musp_v_cm) '_gamma_' num2str(gam) '_g_' num2str(g) '_mua_' num2str(mua_e) '.mat'])
                    continue
                end
                if gam < 1 + 0.6 * g
                	continue
            	end
            	if gam > (exp(1))^(log(3)*g)
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

%For GK

for mua_e = mua_es
    for gamma = gammas
        for g1 = gs
            for musp_v_cm = musp_vs
               
                if gamma < 1 + 0.6 * g1
                    continue
                end
                if gamma > (exp(1))^(log(3)*g1)
                    continue
                end

                gGK = gmap(gamma,g1);
                aGK = amap(gamma,g1);
                [g, gam] = forward_GK_parameters(gGK,aGK);
                
                if isfile(['Test/SFDR/SFDR_mu_' num2str(musp_v_cm) '_gamma_' num2str(gam) '_g_' num2str(g) '_mua_' num2str(mua_e) '_GK.mat'])
                    continue
                end

                data = load(['Test/Simulation_gamma' num2str(gam) '_musp_' num2str(musp_v_cm) '_g_' num2str(g) '_mua_' num2str(mua_e) '_GK.mat']);

                fx = [0 .01 .025 .05:.05:1.8];


                r_log = [data.dr:data.dr:data.dr*data.Ndr] * 10;
                R_log = data.MCoutput.refl_r * 1/100;


                SFDR_1Y = ht(R_log,r_log,fx*2*pi);

                save(['Test/SFDR/SFDR_mu_' num2str(musp_v_cm) '_gamma_' num2str(gam) '_g_' num2str(g) '_mua_' num2str(mua_e) '_GK.mat'],'SFDR_1Y');
            end
        end
    end
end

