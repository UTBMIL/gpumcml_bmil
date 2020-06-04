%% Run MC simulations using Modified HG (Sub-diffuse)
% 2/24/2019
% Yao Zhang

function MCoutput = RunMCw1gamma1g_original(musp_vs,g1)
    %% Input parameters

    Flag_Plot = 0; % 1: Plot the histogram of the scattering angles to check the phase function; 0: no plotting

    mua_v  = linspace(0.01,5,29); % absorption vector (cm^-1)

    photons     = 1E7;   % Number of photon packets to simulate
    n_above     = 1; % Refractive index of the medium above
    n_below     = 1.33;  % Refractive index of the medium below
    dz          = 0.01; % Spatial resolution of detection grid, z-direction [cm]
    dr          = 1*10^(-5); % Spatial resolution of detection grid, r-direction [cm]
    Ndz         = 1;   % Number of grid elements, z-direction
    Ndr         = 1.5*10^5*3;  % Number of grid elements, r-direction
    Nda         = 1;    % Number of grid elements, angular-direction

    %% Run simulation one by one
    g       = g1;         % scattering anisotropy
    for mua_e = mua_v
        mua_d = 100;
        thi = 0;
        for musp_v = musp_vs
            mus = musp_v/(1-g);
            %% Create Input File for MCML
            %             n         mua     mus     g   d    gamma
            if thi == 0
                layers = [1.37      mua_e   mus     g   1E2 1]; % One gamma can use the same exe file
            else
                layers = [1.37      mua_e   mus     g   thi  1;
                    1.37      mua_d   mus     g   1E9  1];
            end

            create_MCML_input_file('mcml',photons,layers,n_above,n_below,dz,dr,Ndz,Ndr,Nda);

            %% Run GPUMCML
            system('./gpumcml.sm_20 mcml.mci') %% Random Seed %% remember to change the data.txt and the name of the program!

            movefile('mcml.mco',['mcml_musp_' num2str(musp_v) '_g_' num2str(g1) '.mco'])

            MCoutput = read_file_mco(['mcml_musp_' num2str(musp_v) '_g_' num2str(g1) '.mco']);

            save(['Test/Simulation_musp_' num2str(musp_v) '_g_' num2str(g1) '_mua_' num2str(mua_e) '.mat'],'dr','MCoutput','Ndr')
        end
    end
end


