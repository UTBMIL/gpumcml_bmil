clear all; close all; clc

interpolant_data = load('g_interpolant');
gmap = interpolant_data.F;
interpolant_data_2 = load('a_interpolant');
amap = interpolant_data_2.F2;

mua_e = 0.01;
mua_d = 0;
thi = 0;


gammas = [1.03,0.99,0.97,1.03,0.99,0.97,1.8,1.44,1.24,1.8,1.44,1.24,2.08,2.14,2.17,2.08,2.14,2.17];
musp_vs = [3.6,2,1.11,5.39,3,1.67,2.26,2,1.54,3.4,3,2.31,2.16,2,1.87,3.25,3,2.8] * 10; %cm^-1
g1s = [.14, .1, .07, .14, .1, .07, .58, .42, .3, .58, .42, .3, .93, .93, .92, .93, .93, .92];


for i = 1:length(gammas)
    gamma = gammas(i);
    g1 = g1s(i);
    musp_v_cm = musp_vs(i);
    
    if gamma > (exp(1))^(log(3)*g1)
        continue
    end

    if gamma <= 1 + g1
        RunMCw1gamma1g_original(gamma,musp_v_cm,g1,mua_e);
    else


        gGK = gmap(gamma,g1);
        aGK = amap(gamma,g1);
        [g, gam] = forward_GK_parameters(gGK,aGK);

        RunMCw1gamma1g_original(gam,musp_v_cm,g,mua_e);
    end
end
%%
close all;
% gammas = linspace(0.95,1.27,20);

% for mua_e = linspace(0.01,5,10);
for mua_e = 0.01
    for i = 1:length(gammas)
        gamma = gammas(i);
        g1 = g1s(i);
        
        musp_v_cm = musp_vs(i);
        
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


