% FORMAT   full = RetrieveRouhnessName(short)
%
% Returns the full roughness name.
%
% OUT  full    Full roughness name
% IN   short   Roughness name shortcut 
%
% 08.01.2021 Vasileios Barlakas (VB) 
%
function full = RetrieveRouhnessName(short)

switch short
    case 'Rough000' 
        full = 'Smooth';
    case 'Rough003'
        full = 'ModeratelyRough';
    case 'Rough050' 
        full = 'SeverelyRough';
end
