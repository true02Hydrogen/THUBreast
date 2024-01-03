function setup()
% Add THUBreast toolbox to the path
% 
% Author: Wang Jiahao
% Mar 10/2022

[root, ~, ~] = fileparts(mfilename('fullpath'));
addpath(root);

addpath(fullfile(root, 'arg'));
addpath(fullfile(root, 'perlin'));
addpath(fullfile(root, 'func'));
% addpath(fullfile(root, 'bct'));

fprintf('THUBreast is ready!\n')