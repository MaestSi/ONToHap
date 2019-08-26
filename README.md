# ONToHap
A MinION-based pipeline for haplotype phasing

**ONToHap** is a .

## Getting started

**Prerequisites**

* Miniconda3.
Tested with conda 4.6.11.
```which conda``` should return the path to the executable.
If you don't have Miniconda3 installed, you could download and install it with:
```
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod 755 Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh
```

**Installation**

```
git clone https://github.com/MaestSi/ONToHap.git
cd ONToHap
chmod 755 *
./install.sh
```

A conda environment named _ONToHap_env_ is created, where seqtk, minimap2, bwa, whatshap, samtools and R are installed. Moreover, HapCUT2 is installed to the _ONToHap_ directory and the executables are linked to the _ONToHap_env_ bin directory.
Then, you can open the **config_ONToHap.R** file with a text editor and set the variables _PIPELINE_DIR_ and _SEQTK_ to the value suggested by the installation step.

## Usage

The ONToHap pipeline can be used either to phase variants stored in a vcf file using ONT long reads or to evaluate the accuracy of variant phasing, comparing the obtained results with a ground-truth phase.
