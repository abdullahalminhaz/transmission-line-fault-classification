clear; clc;

dataFolder = 'data';
files = dir(fullfile(dataFolder,'sample_*.mat'));

fprintf("Loading %d samples...\n", length(files))

%% Containers

Xall = {}; Yall = []; LineAll=[]; DistAll=[]; RfAll=[];

X1={}; Y1=[]; D1=[]; R1=[];
X2={}; Y2=[]; D2=[]; R2=[];
X3={}; Y3=[]; D3=[]; R3=[];

valid_count = 0;

%% Load files

for i = 1:length(files)

    filename = fullfile(dataFolder, files(i).name);

    try
        S = load(filename);
    catch
        fprintf("Skipping corrupted file: %s\n", files(i).name)
        continue
    end

    valid_count = valid_count + 1;

    X = S.Xwin;
    Y = S.L;
    meta = S.meta;

    %% Global dataset

    Xall{end+1} = X;
    Yall(end+1,:) = Y;

    LineAll(end+1,1) = meta.line;
    DistAll(end+1,1) = meta.distance;
    RfAll(end+1,1) = meta.Rf;

    %% Line wise dataset

    if meta.line == 1

        X1{end+1} = X;
        Y1(end+1,:) = Y;
        D1(end+1,1) = meta.distance;
        R1(end+1,1) = meta.Rf;

    elseif meta.line == 2

        X2{end+1} = X;
        Y2(end+1,:) = Y;
        D2(end+1,1) = meta.distance;
        R2(end+1,1) = meta.Rf;

    elseif meta.line == 3

        X3{end+1} = X;
        Y3(end+1,:) = Y;
        D3(end+1,1) = meta.distance;
        R3(end+1,1) = meta.Rf;

    end

    if mod(valid_count,500)==0
        fprintf("%d samples merged\n", valid_count)
    end

end

fprintf("Valid samples loaded: %d\n", valid_count)

%% Convert to Deep Learning format

Xall = cat(3,Xall{:});
Xall = permute(Xall,[3 1 2]);

X1 = cat(3,X1{:});
X1 = permute(X1,[3 1 2]);

X2 = cat(3,X2{:});
X2 = permute(X2,[3 1 2]);

X3 = cat(3,X3{:});
X3 = permute(X3,[3 1 2]);

%% Save datasets

save('TrainAndTestDataset.mat',...
'Xall','Yall','LineAll','DistAll','RfAll','-v7.3')

save('DataLine1.mat','X1','Y1','D1','R1','-v7.3')

save('DataLine2.mat','X2','Y2','D2','R2','-v7.3')

save('DataLine3.mat','X3','Y3','D3','R3','-v7.3')

fprintf("Dataset merging completed successfully\n")