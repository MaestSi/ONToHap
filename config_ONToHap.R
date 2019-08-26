##########################################################################################################
#aligner
aligner <- "Minimap2"
#aligner <- "BWA"
#phaser
#phaser <- "HapCUT2"
phaser <- "Whatshap"
#phaser <- "HapCHAT"
#number of subsamplings
K <- 100
#numerosity of each sample
X <- 10000
##########################################################################################################
SEQTK <- "/home/simone/miniconda3/envs/ONToHap_env/bin/seqtk"
PIPELINE_DIR <- "/home/simone/MinION/MinION_scripts/ONToHap"
#phase_reads.sh
phase_reads <- paste0(PIPELINE_DIR, "/phase_reads.sh")
#combine_iterations.R
combine_iterations <- paste0(PIPELINE_DIR, "/combine_iterations.R")
#combine_phasers
combine_phasers <- paste0(PIPELINE_DIR, "/combine_phasers.R")
#evaluate_accuracy
evaluate_accuracy <- paste0(PIPELINE_DIR, "/evaluate_accuracy.R")
##########################################################################################################
