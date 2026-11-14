# MATLAB / Simulink Source

This directory contains the original MATLAB/Simulink files supplied for the transmission-line fault dataset generation workflow.

## Directory structure

```text
matlab/
├── power_system_model/
│   └── conference_model.slx
├── dataset_generation/
│   ├── dataset_gen.m
│   └── faultActivator.m
└── dataset_merging/
    ├── merge1.m
    └── merge_dataset.m
```

## Files

- `power_system_model/conference_model.slx`: Simulink model used by the generation script. The script references the model as `conference_model`.
- `dataset_generation/dataset_gen.m`: Iterates through three transmission lines, 99 locations, eight fault resistance values, and five operating conditions. It simulates the model, extracts voltage/current signals, filters and normalizes a window, adds noise, labels each sample, and saves individual MAT files under `data/`.
- `dataset_generation/faultActivator.m`: Resets the three fault blocks and configures the selected fault type and switching times.
- `dataset_merging/merge1.m`: Loads individual sample MAT files, groups samples by line, constructs arrays, and saves line-wise and combined MAT datasets.
- `dataset_merging/merge_dataset.m`: Alternative merge script with a `try/catch` that skips corrupted sample files and reports the valid sample count.

## Running the workflow

1. Open MATLAB with Simulink and Simscape Electrical available.
2. Place the `matlab/` directory in your working project, preserving the relative folder structure.
3. Make `matlab/power_system_model/` and `matlab/dataset_generation/` accessible from the MATLAB path, or adjust the working directory and model path as required.
4. Ensure the Simulink model is named `conference_model` and its block names match those referenced in the scripts.
5. Run `dataset_gen.m` from a working directory where the script can create its `data/` folder.
6. After generation, run one of the merge scripts from the directory containing `data/`.

## Important implementation notes

- `dataset_gen.m` uses `fault_time = 0.25`, a nominal extraction window from 0.24 to 0.34 seconds, and random window jitter of 0.005 seconds.
- It applies a fourth-order Butterworth low-pass filter with a 500 Hz cutoff, adds Gaussian noise at a 1% scale, and normalizes using pre-fault statistics.
- The generation script expects the Simulink simulation output to expose `meas_ts` with `Vabc1`–`Vabc3` and `Iabc1`–`Iabc3` time series.
- The script saves individual files as `data/sample_<id>.mat` and is designed to resume from the next sample ID found in that folder.
- The generation loop is configured for 3 lines × 99 locations × 8 resistance levels × 5 conditions = 11,880 combinations. The reported final merged dataset contains 11,879 samples; the difference should be documented as a missing/invalid sample if relevant.
- The two merge scripts use slightly different metadata field names for the combined dataset: `merge1.m` saves `Dall` and `Rall`, while `merge_dataset.m` saves `DistAll` and `RfAll`. Choose the version that matches downstream Python loading code.

These are the supplied original files. No MATLAB code has been rewritten in this bundle.
