clear; clc;

dataFolder = 'data';
files = dir(fullfile(dataFolder, 'sample_*.mat'));

% Containers
X1 = {}; Y1 = []; D1 = []; R1 = [];
X2 = {}; Y2 = []; D2 = []; R2 = [];
X3 = {}; Y3 = []; D3 = []; R3 = [];

Xall = {}; Yall = []; Dall = []; Rall = []; LineAll = [];

fprintf('Loading %d samples...\n', length(files));

for i = 1:length(files)
    S = load(fullfile(dataFolder, files(i).name));

    X = S.Xwin;      % (T x 6)
    Y = S.L;         % (1 x 5)
    meta = S.meta;

    % Store global
    Xall{end+1} = X;
    Yall(end+1,:) = Y;
    Dall(end+1,1) = meta.distance;
    Rall(end+1,1) = meta.Rf;
    LineAll(end+1,1) = meta.line;

    % Store per line
    if meta.line == 1
        X1{end+1} = X; Y1(end+1,:) = Y; D1(end+1,1) = meta.distance; R1(end+1,1) = meta.Rf;
    elseif meta.line == 2
        X2{end+1} = X; Y2(end+1,:) = Y; D2(end+1,1) = meta.distance; R2(end+1,1) = meta.Rf;
    elseif meta.line == 3
        X3{end+1} = X; Y3(end+1,:) = Y; D3(end+1,1) = meta.distance; R3(end+1,1) = meta.Rf;
    end
end

% Convert cell -> array
X1 = cat(3, X1{:}); X1 = permute(X1, [3 1 2]);   % (N,T,6)
X2 = cat(3, X2{:}); X2 = permute(X2, [3 1 2]);
X3 = cat(3, X3{:}); X3 = permute(X3, [3 1 2]);

Xall = cat(3, Xall{:}); Xall = permute(Xall, [3 1 2]);

% Save files
save('DataLine1.mat', 'X1','Y1','D1','R1','-v7.3');
save('DataLine2.mat', 'X2','Y2','D2','R2','-v7.3');
save('DataLine3.mat', 'X3','Y3','D3','R3','-v7.3');

save('TrainAndTestDataset.mat', ...
     'Xall','Yall','LineAll','Dall','Rall','-v7.3');

disp('✅ Dataset merging complete!');