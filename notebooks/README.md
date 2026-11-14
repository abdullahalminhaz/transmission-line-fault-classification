# Python Notebooks

This directory contains the four original Jupyter notebooks supplied for the transmission-line fault classification project. The notebook contents have been preserved; only their filenames have been made consistent and descriptive.

## Notebooks

| File | Purpose |
|---|---|
| `01_exploratory_data_analysis.ipynb` | Dataset inspection and signal exploratory data analysis |
| `02_1d_cnn_fault_classification.ipynb` | 1D-CNN model training and evaluation |
| `03_bilstm_fault_classification.ipynb` | BiLSTM model training and evaluation |
| `04_cnn_bilstm_fault_classification.ipynb` | Hybrid CNN–BiLSTM model training and evaluation |

## Data input

The notebooks load the merged MATLAB v7.3 dataset `TrainAndTestDataset.mat` using `h5py`. They expect the following datasets in the MAT file:

- `Xall`: input time-series array
- `Yall`: one-hot class labels
- `LineAll`: transmission line identifiers
- `DistAll`: fault distance metadata
- `RfAll`: fault resistance metadata

The notebooks transpose `Xall` to obtain samples with shape `(N, 200, 6)` and transpose `Yall` to obtain one-hot labels.

The training notebooks currently mount Google Drive and read the dataset from:

`/content/drive/My Drive/Datasets/TrainAndTestDataset.mat`

Change the path to match your own storage location if necessary.

## Analysis performed

The EDA notebook includes dataset structure and class/metadata distributions, voltage and current waveform inspection, correlation and magnitude analysis, FFT, spectrogram, wavelet analysis, fault energy, symmetrical components, and three-phase trajectory visualizations.

## Model architectures

- **1D-CNN:** Conv1D layers with 32, 64, and 128 filters, batch normalization, max pooling, global average pooling, dense classification layers, and dropout.
- **BiLSTM:** Two bidirectional LSTM layers (128 and 64 units), batch normalization, dense layers, and dropout.
- **CNN–BiLSTM:** Two Conv1D feature-extraction stages followed by bidirectional LSTM layers and dense classification layers.

All three model notebooks use:
- Input shape: `(200, 6)`
- Five output classes
- Adam optimizer with learning rate `0.001`
- Categorical cross-entropy loss
- Stratified 70% training / 15% validation / 15% testing split
- `random_state=42`
- Batch size 64
- Up to 1,000 epochs
- Early stopping and ReduceLROnPlateau callbacks

## Dependencies

The notebooks use:

- Python 3
- NumPy
- Pandas
- h5py
- Matplotlib
- Seaborn
- SciPy
- PyWavelets (`pywt`)
- scikit-learn
- TensorFlow / Keras

The notebooks also use Google Colab's `google.colab.drive` module for mounting Google Drive. If running locally, replace that cell with a local file path. Model visualization cells may require Graphviz and pydot.

## Reproducibility notes

These are the original supplied notebooks, not rewritten implementations. Results depend on the dataset file, software versions, and runtime environment. The notebooks save trained Keras models to Google Drive paths; update those paths if running outside Colab.

The repository's reported model comparison is documented in the research paper. Re-run the notebooks to reproduce the experiments in your own environment.
