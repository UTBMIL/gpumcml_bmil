musp_vs = 3 * 10; %cm^-1
gs = [.9];

mua_v = 0.01



fx = [.01 .025 .05:.05:1.8];


for g = gs
    for mua_e = mua_v
        for musp_v_cm = musp_vs
            R_MCM_data = load('Test/SFDR_MHG/SFDR_mu_10_gamma_1.9_g_0.9_mua_0.01.mat');

            X = R_MCM_data.SFDR_1Y;

            semilogy(fx,X,'--')
%             hold all;
        end
    end
end


xlabel('f')
ylabel('R')