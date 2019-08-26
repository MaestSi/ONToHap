##########################################################################################################
#aligner
aligner <- "Minimap2"
#aligner <- "BWA"
#phaser
#phaser <- "HapCUT2"
phaser <- "Whatshap"
#phaser <- "HapCHAT"
#number of subsamplings
K <- 10
#numerosity of each sample
X <- 1000
##########################################################################################################
SEQTK <- "/path/to/seqtk"
PIPELINE_DIR <- "/path/to/ONToHap"
#phase_reads.sh
phase_reads <- paste0(PIPELINE_DIR, "/phase_reads.sh")
#combine_iterations.R
combine_iterations <- paste0(PIPELINE_DIR, "/combine_iterations.R")
#combine_phasers
combine_phasers <- paste0(PIPELINE_DIR, "/combine_phasers.R")
#evaluate_accuracy
evaluate_accuracy <- paste0(PIPELINE_DIR, "/evaluate_accuracy.R")
##########################################################################################################
