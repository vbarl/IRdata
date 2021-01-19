% FORMAT   ConvertYang2ARTS4Range(wfolder[,wid])
%
% Initiates data format conversion of the Ping Yang's single scattering data. 
% From ascii format towards the ARTS format (xml). The conversion is conducted
% for each wavelength range separately. For details, the reader is referred to 
% README_ice.txt.
%  
% OUT  *.xml     ARTS single scattering data in xml format
%         
% IN   wfolder   Input folder options: 
%                'Data_0.2_15.25/' 
%                'Data_16.4_99.0/'
%           
% OPT  wid       Wavelenght id to be used in the output filename
% 
% 04.01.2021 Vasileios Barlakas (VB) 
%
% EXP  ConvertYang2ARTS('Data_16.4_99.0/','Lambda_016mu_100mu')
%      ConvertYang2ARTS('Data_0.2_15.25/','Lambda_002mu_016mu')
%
function ConvertYang2ARTS4Range(wfolder,wid)
if nargin < 2, wid =''; end

[nrows,ncols,nw,nsizes] = DataSpecs(wfolder);

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
        
        %- Define input/output paths
        paths = SwitchUser(wfolder, ihabit, iroughness);
        
        %- Data and unit conversion
        [S,M] = Yang2ARTS(nrows,ncols,nw,nsizes,ihabit,paths.habit);
        
        Mindex = num2cell(M);
        Sindex = num2cell(S);
        
        %- Retrieve full roughness name
        FullRoughness = RetrieveRouhnessName(iroughness);
        
        %- Retrieve habit output name
        [FullHabitName,OutName] = RetrieveFullName(ihabit);
        
        %- Store the xml data
        xmlStore([paths.output, wid, '_', OutName, '-',FullRoughness, '.meta.xml'], ...
            Mindex, 'ArrayOfScatteringMetaData')
        xmlStore([paths.output, wid, '_' ,OutName, '-', FullRoughness, '.xml']         ,...
            Sindex, 'ArrayOfSingleScatteringData', 'binary')
    end % rindex
end % loop over hindex
