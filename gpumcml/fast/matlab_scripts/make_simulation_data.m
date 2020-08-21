clear all; close all; clc

interpolant_data = load('g_interpolant');
gmap = interpolant_data.F;
interpolant_data_2 = load('a_interpolant');
amap = interpolant_data_2.F2;

% musp_vs = [linspace(5,60,50) linspace(60,100,20) linspace(100, 200, 20)];
% %mua_es = [linspace(.01,5,29) 6 7];
% mua_es = 0.01;
% gammas = [linspace(0.62, 0.7, 6) linspace(0.7,0.95,6) linspace(0.95,2,30) linspace(2,2.2,6)];
% thi_v = linspace(0.05,0.2,4);
% 
% %gs = [0.1 0.3 0.5 0.9];
% gs = 0.9;
% 
% %musp_vs = musp_vs(1:2:end);
% %mua_es = mua_es(1:2:end);
% %gammas = gammas(1:2:end);
% 
% gammas = linspace(0.63, 0.7, 3);
% musp_vs = musp_vs(2:10:end);
% %gammas = gammas(2:8:end);
% 
% %gammas = gammas(14);
% 
% %musp_vs = [70 80 90];
% 
% %g = 0.9;

musp_vs = 20;
gs = 0.9;
mua_es = 0.01;
gammas = 2.14;
thi_v = [0.05, 0.2, 100];

for gamma = gammas
    for g1 = gs
        for mua_e = mua_es

            musp_v_cm = musp_vs;

            if gamma > (exp(1))^(log(3)*g1)
                continue
            end

            if gamma <= 1 + g1
                RunMCw1gamma1g_original(gamma,musp_v_cm,g1,mua_e,thi_v);
            else


                gGK = gmap(gamma,g1);
                aGK = amap(gamma,g1);
                [g, gam] = forward_GK_parameters(gGK,aGK);

                RunMCw1gamma1g_GK(gam,musp_v_cm,g,mua_e, thi_v);

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
                for thi = thi_v
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





                    if isfile(['Test/SFDR/SFDR_mu_' num2str(musp_v_cm) '_gamma_' num2str(gam) '_g_' num2str(g) '_mua_' num2str(mua_e) '_thi_' num2str(thi) '.mat'])
                        continue
                    end

                    data = load(['Test/Simulation_gamma' num2str(gam) '_musp_' num2str(musp_v_cm) '_g_' num2str(g) '_mua_' num2str(mua_e) '_thi_' num2str(thi) '.mat']);

                    fx = [0 .01 .025 .05:.05:1.8];


                    r_log = [data.dr:data.dr:data.dr*data.Ndr] * 10;
                    R_log = data.MCoutput.refl_r * 1/100;


                    SFDR_1Y = ht(R_log,r_log,fx*2*pi);

                    save(['Test/SFDR/SFDR_mu_' num2str(musp_v_cm) '_gamma_' num2str(gam) '_g_' num2str(g) '_mua_' num2str(mua_e) '_thi_' num2str(thi) '.mat'],'SFDR_1Y');
                end
            end
        end
    end
end


