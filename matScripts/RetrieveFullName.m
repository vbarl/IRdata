% FORMAT   [full,out] = RetrieveFullName(short)
%
% Full habit name and corresponding output name.
%
% OUT  full    Full habit name
%      out     Habit name for output file
% IN   short   Habit name shortcut 
%
% 08.01.2021 Vasileios Barlakas (VB) 
%
function [full,out] = RetrieveFullName(short)

switch short
    case '5_plates/' 
        full = '5-element plate aggregate';
        out = '5-PlateAggregate';
    case '8_columns/'
        full = '8-element column aggregate';
        out = '8-ColumnAggregate';
    case '10_plates/' 
        full = '10-element plate aggregate';
        out = '10-PlateAggregate';
    case 'droxtal/'
        full = 'Droxtal';
        out = 'Droxtal';
    case 'HBR/' 
        full = 'Hollow bullet rosette';
        out = 'HollowBulletRosette';
    case 'hollow_column/'
        full = 'Hollow column';
        out = 'HollowColumn';
    case 'plate/' 
        full = 'Plate';
        out = 'Plate';
    case 'SBR/'
        full = 'Solid bullet rosette';
        out = 'SolidBulletRosette';
    case 'single_column/'
        full = 'Hexagonal column';
        out = 'HexagonalColumn';
end
