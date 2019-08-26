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
SEQTK <- "/home/simone/miniconda3/envs/Phasing_pipeline_env/bin/seqtk"
pipeline_dir <- "/home/simone/MinION/MinION_scripts/phasing_pipeline"
#phase_reads.sh
phase_reads <- paste0(pipeline_dir, "/phase_reads.sh")
#combine_iterations.R
combine_iterations <- paste0(pipeline_dir, "/combine_iterations.R")
#combine_phasers
combine_phasers <- paste0(pipeline_dir, "/combine_phasers.R")
#evaluate_accuracy
evaluate_accuracy <- paste0(pipeline_dir, "/evaluate_accuracy.R")
##########################################################################################################
