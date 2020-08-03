clear all; close all; clc

interpolant_data = load('g_interpolant');
gmap = interpolant_data.F;
interpolant_data_2 = load('a_interpolant');
amap = interpolant_data_2.F2;

musp_vs = linspace(5,60,50);
mua_es = linspace(.01,5,29);
gammas = [linspace(0.95,2,30) linspace(2,2.2,6)];

gs = [0.1 0.3 0.5 0.9];

%musp_vs = linspace(5,60,5);
%mua_es = linspace(.01,5,7);
%gammas = linspace(0.95,2.2,5);
%gs = 0.9;

%gammas = linspace(2,2.2,6);

musp_vs = musp_vs(1:2:end);
mua_es = mua_es(1:2:end);
gammas = gammas(1:2:end);


for gamma = gammas
    for g1 = gs
        for mua_e = mua_es
            musp_v_cm = musp_vs;
            
            if gamma > (exp(1))^(log(3)*g1)
                continue
            end
            
            if gamma <= 1 + g1
                RunMCw1gamma1g_original(gamma,musp_v_cm,g1,mua_e);
            else
            
            
                gGK = gmap(gamma,g1);
                aGK = amap(gamma,g1);
                [g, gam] = forward_GK_parameters(gGK,aGK);

                RunMCw1gamma1g_GK(gam,musp_v_cm,g,mua_e);
            end
            
        end
    end  
end
%%
close all;
%for MHG

for mua_e = mua_es
    for gamma = gammas
        for g1 = gs
            for musp_v_cm = musp_vs
                if gamma > (exp(1))^(log(3)*g1)
                    continue
                end
                
                if gamma > 1 + g1
                    gGK = gmap(gamma,g1);
                    aGK = amap(gamma,g1);
                    [g, gam] = forward_GK_parameters(gGK,aGK);
                else
                    g = g1;
                    gam = gamma;
                end
                
                

                
                
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


