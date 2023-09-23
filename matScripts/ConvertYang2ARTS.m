% FORMAT   ConvertYang2ARTS([wid])
%
% Initiates data format conversion of the Ping Yang's single scattering data. 
% From ascii format towards the ARTS format (xml). It combines the two 
% wavelength ranges, i.e., 0.2 ~15.25 mu (396 wavelengths) and 16.4~99.0
% mu (49 wavelengths), into a single wavelength file 0.2~99.0 (445
% wavelegths).  For details, the reader is referred to README_ice.txt.
%  
% OUT  *.xml     ARTS single scattering data in xml format
% 
% OPT  wid       Wavelenght id to be used in the output filename
% 
% 04.01.2021 Vasileios Barlakas (VB) 
%
% EXP  ConvertYang2ARTS('Lambda_002mu_100mu')
%      
%
function ConvertYang2ARTS(wid)
if nargin < 1, wid =''; end

%- Specs for each wavelength range; nsizes is the same
[nrows1,ncols1,nw1,nsizes] = DataSpecs('Data_16.4_99.0/');
[nrows2,ncols2,nw2,nsizes] = DataSpecs('Data_0.2_15.25/');

ihabits = {'5_plates/','8_columns/','10_plates/','droxtal/',...
    'HBR/','hollow_column/','plate/','SBR/','single_column/'};

iroughs = {'Rough000','Rough003','Rough050'};


%- Loop over habit
for hindex = 1:length(ihabits)
    ihabit = ihabits{hindex};
    disp('-------------------------------------------------------')
    fprintf('Converting data for habit = %s\n', ihabit);
    
    %- Loop over surface roughness
    for rindex = 1:length(iroughs)
        
        iroughness = iroughs{rindex};
        fprintf('and roughness = %s\n', iroughness);
        
        %- Define input/output paths for wavelength range 1
        paths1 = SwitchUser('Data_16.4_99.0/', ihabit, iroughness);
        
        %- Data and unit conversion for low wavelength
        [S1,M1] = Yang2ARTS(nrows1,ncols1,nw1,nsizes,ihabit,paths1.habit);
        disp('High wavelengths done')
        
        %- Define input/output paths for wavelegth range 2
        paths2 = SwitchUser('Data_0.2_15.25/', ihabit, iroughness);
        
        %- Data and unit conversion
        [S2,M2] = Yang2ARTS(nrows2,ncols2,nw2,nsizes,ihabit,paths2.habit);
	disp('Low wavelengths done')

        %- Merge the two structs/wavelegth ranges
        for isize = 1:nsizes
	   %------------------ SORTING in frequency (not in wavelength)
           S1(isize).f_grid=flip(S1(isize).f_grid,1);
	   S2(isize).f_grid=flip(S2(isize).f_grid,1);

	   S1(isize).ext_mat_data=flip(S1(isize).ext_mat_data,1);
           S2(isize).ext_mat_data=flip(S2(isize).ext_mat_data,1);

           S1(isize).abs_vec_data=flip(S1(isize).abs_vec_data,1);
           S2(isize).abs_vec_data=flip(S2(isize).abs_vec_data,1);

           S1(isize).pha_mat_data=flip(S1(isize).pha_mat_data,1);
           S2(isize).pha_mat_data=flip(S2(isize).pha_mat_data,1);
	   %------------------
           S1(isize).f_grid=[S1(isize).f_grid; S2(isize).f_grid];
           S1(isize).ext_mat_data=[S1(isize).ext_mat_data; S2(isize).ext_mat_data]; 
           S1(isize).abs_vec_data=[S1(isize).abs_vec_data; S2(isize).abs_vec_data];
           S1(isize).pha_mat_data=[S1(isize).pha_mat_data; S2(isize).pha_mat_data];
        end

        %- M1 and M2 are equivalent
        Mindex = num2cell(M1);
        Sindex = num2cell(S1);
        
        %- Retrieve full roughness name
        FullRoughness = RetrieveRouhnessName(iroughness);
        
        %- Retrieve habit output name
        [FullHabitName,OutName] = RetrieveFullName(ihabit);
        disp('Storing start') 
        %- Store the xml data (paths1.output and paths2.output are identical)
        xmlStore([paths1.output, wid, OutName, '-',FullRoughness, '.meta.xml'], ...
            Mindex, 'ArrayOfScatteringMetaData')
        xmlStore([paths1.output, wid ,OutName, '-', FullRoughness, '.xml']         ,...
            Sindex, 'ArrayOfSingleScatteringData', 'binary')
        disp('Storing done')
    end % rindex
end % loop over hindex
