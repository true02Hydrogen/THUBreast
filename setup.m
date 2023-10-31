function setup()
% Add breastPhantom toolbox to the path
% 
% Author: Wang Jiahao
% Mar 10/2022

[root, ~, ~] = fileparts(mfilename('fullpath'));
addpath(root);

addpath(fullfile(root, 'arg'));
addpath(fullfile(root, 'perlin'));
addpath(fullfile(root, 'bct'));
% addpath(fullfile(root, 'toGraff'));

fprintf('THUBreast is ready!\n')