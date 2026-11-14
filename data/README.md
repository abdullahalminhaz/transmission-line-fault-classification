# Dataset Information

## Overview

This project uses a MATLAB/Simulink-generated multivariate electrical signal dataset for transmission line fault classification.

The dataset contains synchronized three-phase voltage and current measurements collected under different transmission line fault conditions.

## Dataset Specifications

| Parameter | Value |
|---|---|
| Total samples | 11,879 |
| Fault classes | 5 |
| Transmission lines | 3 |
| Fault locations | 1–99 km |
| Fault resistance levels | 8 |
| Input channels | 6 |
| Time-series window | 200 samples |
| Input shape | 200 × 6 |

## Data Availability

The complete dataset is not publicly distributed in this repository.

The MATLAB/Simulink model and dataset-generation scripts are provided to document the simulation methodology and enable independent dataset generation.

## Dataset Generation

Refer to:

- `matlab/power_system_model/`
- `matlab/dataset_generation/`
- `matlab/dataset_merging/`

For details about signal acquisition, preprocessing, labeling, and dataset organization, see `docs/dataset_generation_methodology.pdf`.

## Input Signals

- Va: Phase-A voltage
- Vb: Phase-B voltage
- Vc: Phase-C voltage
- Ia: Phase-A current
- Ib: Phase-B current
- Ic: Phase-C current

## Metadata

Each sample includes:

- Transmission line number
- Fault location
- Fault type
- Fault resistance

**Note:** The complete research dataset is retained separately and is not included in this public repository.
