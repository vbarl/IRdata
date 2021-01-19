% FORMAT   [S,M] = Yang2ARTS(nrows,ncols,nw,nsizes,habit,hfolder)
%
% Converts Ping Yang's single scattering data (ascii) to the 
% corresponding ARTS format (xml). 
%
% OUT  S        Vector of SingleScatteringData
%      M        Vector of ScatteringMetaData
%
% IN   nrows    Number of rows = wavelenght x particle sizes
%      ncols    Number of columns = SSP
%      nw       Number of wavelenghts
%      nsizes   Number of sizes
%      habit    Hydrometeor habit
%      hfolder  Habit folder
%
% 04.01.2021 Vasileios Barlakas (VB) 
%
function [S,M] = Yang2ARTS(nrows,ncols,nw,nsizes,habit,hfolder)

%- Load single scattering data
ntheta = 498;                                           % scattering angle [deg]
fSSD    = fopen(fullfile(hfolder, 'isca.dat'));
data    = textscan(fSSD, '%f');
SSD     = single(permute(reshape(data{1}, ncols, nrows), [2 1]));
fclose(fSSD);						  % close the file

lambda = single(zeros(1,nw));
for i = 1:nw
    %- Wavelength [um => m]
    lambda(i) = 1e-6.*SSD(nsizes*i);      
end

%- Wavelength [m] to frequency [Hz]
freq = constants('SPEED_OF_LIGHT')./lambda;

%- Maximum dimension of the particle [um => m]
dmax = 1e-6.*SSD(1:nsizes,2);

%- Volume of particle [um3 => m3]
volume = 1e-18.*SSD(1:nsizes,3);

%- Projected area [um2 => m2]
area = 1e-12.*SSD(:,4);
area = reshape(area,nsizes,nw);

%- Extinction efficiency [-]
qext = SSD(:,5);
qext = reshape(qext,nsizes,nw);

%- Single scattering albedo [-]
ssa = SSD(:,6);
ssa = reshape(ssa,nsizes,nw);

%- Asymmetry parameter [-]
asy = SSD(:,7);
asy = reshape(asy,nsizes,nw);

%- Efficiency [-] to cross section [m2]
cext = qext.*area;           % extinction
csca = cext.*ssa;             % scattering
cabs = cext-csca;            % absorption

%- Extend dimension to match phase matrix one (nsizes,nw,ntheta)
csca_mat = repmat(csca,1,1,ntheta);

%- Particle mass [kg] 
mass = constants('DENSITY_OF_ICE').*volume; % [kg m-3 * m3]

%- Volume equivalent diameter [m]
dveq = (6.*volume./pi).^(1/3);

%- Aerodynamical area equivalent diameter 
daer = NaN(size(dveq));

%- Temperature
temp  = 266;

%- Load phase matrix elements [- => m2]
phat_mat = single(zeros(nsizes,nw,ntheta,1,1,1,6)); 
phat_ij     = single(zeros(nsizes,nw,ntheta));

phat = {'P11.dat','P12.dat','P22.dat','P33.dat',...
    'P43.dat','P44.dat'};

%- Loop over phase matrix elements files
for phat_index = 1:length(phat)
    iphat   = phat{phat_index};
    fPHAT  = fopen(fullfile(hfolder, iphat));
    PHAT   = textscan(fPHAT, '%f32');
    phat_ij = permute(reshape(PHAT{1}((ntheta+1):end), ntheta, nsizes, nw), [2, 3, 1]);
    phat_mat(:,:,:,1,1,1,phat_index) = phat_ij;
    fclose(fPHAT);
end

%- Phase matrix elements but for P11 are normalized by P11 
%- all elements are normalized by 4pi/csca
normfac = csca_mat./(4*pi);
for k = 2:6
    phat_mat(:,:,:,1,1,1,k) = phat_mat(:,:,:,1,1,1,k).*phat_mat(:,:,:,1,1,1,1).*normfac; 
end

%- Denormalization of P11
phat_mat(:,:,:,1,1,1,1) = phat_mat(:,:,:,1,1,1,1).*normfac;

%- P34 = - P43
phat_mat(:,:,:,1,1,1,5) = -phat_mat(:,:,:,1,1,1,5);

theta = PHAT{1}(1:ntheta);
[FullHabitName,OutName] = RetrieveFullName(habit);

%- Create SingleScatteringData (S) and ScatteringMetaData (M) 
%- for ARTS-XML
S = struct([]);
M = struct([]);

for isize = 1:nsizes
    %- M
    M(isize).version                   = 3;
    M(isize).description               = ['Meta data for ' FullHabitName,', following P. Yang (2013) and Bi, L., and P. Yang (2017).'];
    M(isize).source                    = 'P. Yang (2013) and Bi, L., and P. Yang (2017)';
    M(isize).refr_index                = 'Warren and Brandt (2008)';
    M(isize).mass                      = mass(isize);
    M(isize).diameter_max              = dmax(isize);
    M(isize).diameter_volume_equ       = dveq(isize);
    M(isize).diameter_area_equ_aerodynamical = daer(isize);

    %- S
    S(isize).version                   = 3;
    S(isize).ptype                     = 'totally_random';
    S(isize).description               = [FullHabitName, ', following P. Yang (2013) and Bi, L., and P. Yang (2017).'];
    S(isize).f_grid                    = freq';
    S(isize).T_grid                    = temp; % QUESTION
    S(isize).za_grid                   = theta;
    S(isize).aa_grid                   = [];
    S(isize).pha_mat_data = permute(phat_mat(isize,:,:,:,:,:,:), [2,1,3,4,5,6,7]);
    S(isize).ext_mat_data = cext(isize,:).';
    S(isize).abs_vec_data = cabs(isize,:).';
end    
