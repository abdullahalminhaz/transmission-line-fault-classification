clear; clc; close all;
rng(1);

%% Create data folder
if ~exist('data','dir')
    mkdir data
end

%% Resume from last sample
files = dir('data/sample_*.mat');

if isempty(files)
    sample_id = 1;
else
    names = {files.name};
    ids = cellfun(@(x) sscanf(x,'sample_%d.mat'), names);
    sample_id = max(ids) + 1;
end

fprintf("Starting generation from sample %d\n", sample_id)

%% PARAMETERS

fault_time = 0.25;

base_t1 = 0.24;
base_t2 = 0.34;

window_jitter = 0.005;
noise_level = 0.01;

L1 = 1:1:99;
L2 = 100 - L1;

FR = [0.25 0.5 5 10 25 50 75 100];

ftype = {'LG','LL','LLG','LLL','none'};

samples_per_location = length(FR) * length(ftype);   % 40
samples_per_line = length(L1) * samples_per_location; % 3960

total_samples = 3 * samples_per_line;

%% MAIN LOOP

for sid = sample_id:total_samples

    %% Decode indices from sample id

    sid0 = sid - 1;

    line_id = floor(sid0 / samples_per_line) + 1;

    rem_line = mod(sid0, samples_per_line);

    loc_index = floor(rem_line / samples_per_location) + 1;

    rem_loc = mod(rem_line, samples_per_location);

    fr_index = floor(rem_loc / length(ftype)) + 1;

    fault_index = mod(rem_loc, length(ftype)) + 1;

    %% Assign values

    distance = L1(loc_index);
    Rf = FR(fr_index);
    fault_type = ftype{fault_index};

    %% Configure line parameters

    if line_id == 1

        set_param('conference_model/L_1_1','Length',num2str(distance));
        set_param('conference_model/L_1_2','Length',num2str(100-distance));

        set_param('conference_model/L_2_1','Length','50');
        set_param('conference_model/L_2_2','Length','50');
        set_param('conference_model/L_3_1','Length','50');
        set_param('conference_model/L_3_2','Length','50');

        fb = 'Fault_1';

    elseif line_id == 2

        set_param('conference_model/L_2_1','Length',num2str(distance));
        set_param('conference_model/L_2_2','Length',num2str(100-distance));

        set_param('conference_model/L_1_1','Length','50');
        set_param('conference_model/L_1_2','Length','50');
        set_param('conference_model/L_3_1','Length','50');
        set_param('conference_model/L_3_2','Length','50');

        fb = 'Fault_2';

    else

        set_param('conference_model/L_3_1','Length',num2str(distance));
        set_param('conference_model/L_3_2','Length',num2str(100-distance));

        set_param('conference_model/L_1_1','Length','50');
        set_param('conference_model/L_1_2','Length','50');
        set_param('conference_model/L_2_1','Length','50');
        set_param('conference_model/L_2_2','Length','50');

        fb = 'Fault_3';

    end

    %% Set fault resistance

    set_param(['conference_model/' fb],'FaultResistance',num2str(Rf));

    faultActivator(fb,fault_type);

    %% Run simulation

    out = sim('conference_model.slx','StartTime','0','StopTime','0.7');

    %% Extract signals

    Vts = out.meas_ts.(['Vabc' num2str(line_id)]);
    Its = out.meas_ts.(['Iabc' num2str(line_id)]);

    t = Vts.Time;
    V = Vts.Data;
    I = Its.Data;

    %% Filtering

    fs = 1 / mean(diff(t));
    fc = 500;

    [b,a] = butter(4, fc/(fs/2));

    V = filtfilt(b,a,V);
    I = filtfilt(b,a,I);

    X = [V I];

    %% Window

    dt = window_jitter * randn;

    t1 = base_t1 + dt;
    t2 = base_t2 + dt;

    idx = (t >= t1) & (t <= t2);

    Xwin = X(idx,:);

    %% Noise

    Xwin = Xwin + noise_level * std(Xwin(:)) * randn(size(Xwin));

    %% Pre-fault normalization

    pre_idx = (t >= (fault_time - 0.05)) & (t < fault_time);

    Xpre = X(pre_idx,:);

    mu = mean(Xpre,1);
    sigma = std(Xpre,[],1);

    sigma(sigma==0) = 1;

    Xwin = (Xwin - mu) ./ sigma;

    %% Label

    L = zeros(1,5);
    L(fault_index) = 1;

    %% Metadata

    meta.line = line_id;
    meta.distance = distance;
    meta.fault_type = fault_type;
    meta.Rf = Rf;

    %% Save sample

    filename = sprintf('data/sample_%d.mat', sid);

    save(filename,'Xwin','L','meta','-v7.3');

    %% Print every sample

    fprintf("Sample %d | Line %d | Location %d | Rf %.2f | Fault %s\n", ...
        sid,line_id,distance,Rf,fault_type)

    %% Clear memory

    clear out Vts Its V I X Xwin Xpre t

    %% Reset Simulink periodically

    if mod(sid,30)==0
        bdclose all
        load_system('conference_model')
        fprintf("Simulink reset at sample %d\n", sid)
    end

end

fprintf("Dataset generation completed. Total samples = %d\n", total_samples);