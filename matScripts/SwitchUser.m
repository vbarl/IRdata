% FORMAT   paths = SwitchUser(wfolder, ihabit, iroughness)
%
% It automatically defines the user, but the user has
% to manually set her/his working directories.
%
% OUT   paths        Structure with paths to files/folders
%
% IN    wfolder      Input folder options
%       ihabit       Hydrometeor habit
%       iroughness   Surface roughness
%
% 04.01.2021 Vasileios Barlakas (VB)
%
function paths = SwitchUser(wfolder, ihabit, iroughness)

%- Define user and paths
switch whoami
  case 'barlakas'
     %- Location of ascii data to be converted
     paths.habit = ['/home/barlakas/Documents/Dendrite/ScatData/Yang2013/', ...
                    wfolder, ihabit, iroughness];
     
     %- Output path
     paths.output = ['/home/barlakas/WORKAREA/IRdata/SSD/Yang2013/'];
     
  case 'patrick'
     %- Location of ascii data to be converted
     paths.habit = ['/home/patrick/Tmp/Yang2016/YangFormat/', ...
                    wfolder, ihabit, iroughness];
     
     %- Output path
     paths.output = ['/home/patrick/Tmp/Yang2016/ArtsFormat/'];

  otherwise
     error('Uknown user');
end


if ~exist(paths.habit, 'dir')
    error('Wrong path for input was given');
end

%- Create main output folder?
if ~exist(paths.output, 'dir')
    mkdir(paths.output);
end
