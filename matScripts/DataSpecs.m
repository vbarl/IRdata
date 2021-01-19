% FORMAT   [nrows,ncols,nw,nsizes] = DataSpecs(wfolder)
%
% The data within the two directories are characterized by different specs.
% It returns the different specs following the given directory. For details, 
% the reader is referred to README_ice.txt.
%  
% OUT   nrows    Number of rows = wavelenght x particle sizes
%       ncols    Number of columns = SSP
%       nw       Number of wavelenghts
%       nsizes   Number of sizes
% IN    wfolder  Input folder options 
% 
% 04.01.2021 Vasileios Barlakas (VB) 
%
function [nrows,ncols,nw,nsizes] = DataSpecs(wfolder)

switch wfolder
    case 'Data_0.2_15.25/' 
        nrows = 74844;
        nw     = 396;
    case 'Data_16.4_99.0/'
        nrows = 9261;
        nw      = 49;
end
ncols   = 7;
nsizes = 189;
end
