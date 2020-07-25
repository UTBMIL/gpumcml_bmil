%% Run MC simulations using Modified HG (Sub-diffuse)
% 2/24/2019
% Yao Zhang

function MCoutput = RunMCw1gamma1g_GK(gamma,musp_vs,g1,mua_v)
    interpolant_data = load('g_interpolant')
    gmap = interpolant_data.F;
    interpolant_data_2 = load('a_interpolant')
    amap = interpolant_data_2.F2;

    %% Input parameters
%     mua_v  = [0.01]; % absorption vector (cm^-1)\
    
    %First check if these files already all exist
    %Default assumption is they do exist
    exist_flag = 1;
    
    gammas  = gamma;      % Gamma
    for mua_e = mua_v
        for gamma = gammas % To run multiple values of gammas we will need to change the exe.file. Please use one gamma each time for now
            for musp_v = musp_vs
                if isfile(['Test/Simulation_gamma' num2str(gamma) '_musp_' num2str(musp_v) '_g_' num2str(g1) '_mua_' num2str(mua_e) '_GK.mat'])
                    continue;
                else
                    exist_flag = 0;
                end
            end
        end
    end
    
    if exist_flag == 1
        fprintf("skipping \n")
        return;
    end
    

    Flag_Plot = 1; % 1: Plot the histogram of the scattering angles to check the phase function; 0: no plotting

    % musp_vs = [30];% reduced scattering vector (cm^-1)  (Test one value here but you can have multiple values)
    
%     mua_v = linspace(0.01,5,10);

    photons     = 1E7;   % Number of photon packets to simulate
    n_above     = 1; % Refractive index of the medium above
    n_below     = 1.33;  % Refractive index of the medium below
    dz          = 0.01; % Spatial resolution of detection grid, z-direction [cm]
    dr          = 1*10^(-5); % Spatial resolution of detection grid, r-direction [cm]
    Ndz         = 1;   % Number of grid elements, z-direction
    Ndr         = 1.5*10^5*3;  % Number of grid elements, r-direction
    Nda         = 1;    % Number of grid elements, angular-direction

    %% Sampling for MHG to generate inverse CDF in data.txt
    % (You can skip this step if you made a file for the current pair of g and gamma previously)
    tic
    N=20000;
    epsilon=linspace(0,1,N); % Uniform Distribution
    A=[];

    if isfile(['CDF_g_' num2str(g1) 'gamma_' num2str(gamma) '_GK.txt'])
        %do nothing
    else
        for Num=1:size(gamma,2)


            costC=zeros(N,1);
            for time=1:N
                
                gGK = gmap(gamma,g1);
                aGK = amap(gamma,g1);
		[g1debug, gammadebug] = forward_GK_parameters(gGK,aGK)               
 
                randnum=epsilon(time);
                K = aGK*gGK*(1-gGK^2)^(2*aGK)/((1 + gGK)^(2*aGK) - (1 - gGK)^(2*aGK));
                leci = aGK * gGK * randnum/K + (1 + gGK)^(-2*aGK);
                costT = 1/(2*gGK)*(1 + gGK^2 - 1/(leci^(1/aGK)));
                costC(time)=costT;
            end
            A=[A costC];
            % Plot
            if Flag_Plot
                figure
                h0=histogram(costC,21,'Normalization','pdf');
                hold on
                %theoretical MHG phase function
                cost0=linspace(-1,1,N);
                pcost0=2*aGK*gGK*(1-gGK^2)^(2*aGK)/((1 + gGK)^(2*aGK)-(1-gGK)^(2*aGK))*1./(1 + gGK^2 - 2*gGK*cost0).^(1 + aGK);
                plot(cost0,pcost0);
                set(gca, 'YScale', 'log')
                xlabel('cos(\theta)')
                ylabel('probability')
                legend('Sampling (Numeric/Discretized)','GK phase function')
                title(['g1=',num2str(g1),' gamma=',num2str(gamma(Num))])
                xlim([-1 1])
                ylim([10^(-3) 10^2])
            end
        end
        toc

        fileID = fopen(['CDF_g_' num2str(g1) 'gamma_' num2str(gamma) '_GK.txt'],'w');
        formatSpec='%8.6f \n';
        fprintf(fileID,formatSpec,A'); % Very important!!! Pay attention to the writing format!
        fclose(fileID);
        %save(['CDF_g_' num2str(g1) 'gamma_' num2str(gamma) '.mat'])
    end


    %% Always run this to replace data.txt with the desired inverse CDF file
    copyfile(['CDF_g_' num2str(g1) 'gamma_' num2str(gamma) '_GK.txt'],'data.txt')


    %% Run simulation one by one
    g       = g1;         % scattering anisotropy
    gammas  = gamma;      % Gamma
    for mua_e = mua_v
        mua_d = 100;
        thi = 0;
        for gamma = gammas % To run multiple values of gammas we will need to change the exe.file. Please use one gamma each time for now
            for musp_v = musp_vs
                if isfile(['Test/Simulation_gamma' num2str(gamma) '_musp_' num2str(musp_v) '_g_' num2str(g1) '_mua_' num2str(mua_e) '_GK.mat'])
                    continue;
                end
                
                
                mus = musp_v/(1-g);
                %% Create Input File for MCML
                %             n         mua     mus     g   d    gamma
                if thi == 0
                    layers = [1.37      mua_e   mus     g   1E2 1]; % One gamma can use the same exe file
                else
                    layers = [1.37      mua_e   mus     g   thi  1;
                        1.37      mua_d   mus     g   1E9  1];
                end

                create_MCML_input_file('mcml','data.txt',photons,layers,n_above,n_below,dz,dr,Ndz,Ndr,Nda);

                %% Run GPUMCML
                system('./gpumcml.sm_20 mcml.mci') %% Random Seed %% remember to change the data.txt and the name of the program!

                movefile('mcml.mco',['mcml_gamma' num2str(gamma) '_musp_' num2str(musp_v) '_g_' num2str(g1) '.mco'])

                MCoutput = read_file_mco(['mcml_gamma' num2str(gamma) '_musp_' num2str(musp_v) '_g_' num2str(g1) '.mco']);

                %% Plot the simulation results
                %         figure
                %         r = 0:dr:dr*Ndr-dr;
                %         Rd_r = MCoutput.refl_r;
                %         semilogy(r,Rd_r,'--'); % Rd_r from MCML simulation output
                %         xlabel('Radius r [cm]')
                %         ylabel('Diffuse reflectance R_d (cm^-^2)')
                %         title(['musp =', num2str(musp_v/10),' mm^-^1 g1 =',num2str(g), ' gamma =',num2str(gamma)])

                save(['Test/Simulation_gamma' num2str(gamma) '_musp_' num2str(musp_v) '_g_' num2str(g1) '_mua_' num2str(mua_e) '_GK.mat'],'dr','MCoutput','Ndr')
            end
        end
    end
end


