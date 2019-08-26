args = commandArgs(trailingOnly=TRUE)

if (args[1] == "-h" | args[1] == "--help") {
  cat("", sep = "\n")
  cat(paste0("Usage: Rscript phasing_pipeline.R <home_dir>"), sep = "\n")
  cat(paste0("<home_dir>: directory containing a fastq file, an unphased_file.vcf and a reference.fasta file for a single sample"), sep = "\n")
  stop(simpleError(sprintf("\r%s\r", paste(rep(" ", getOption("width")-1L), collapse=" "))))
}

home_dir <- args[1]

PIPELINE_DIR <- dirname(strsplit(commandArgs(trailingOnly = FALSE)[4],"=")[[1]][2])
CONFIG_FILE <- paste0(PIPELINE_DIR, "/config_phasing_pipeline.R")
source(CONFIG_FILE)
source(combine_iterations)

#fastq reads
fastq_reads_file <- list.files(path = home_dir, pattern = "\\.fastq", full.names = TRUE)
#unphased VCF file
unphased_VCF_file <- list.files(path = home_dir, pattern = "unphased_file\\.vcf", full.names = TRUE)
#reference sequence
reference_seq <- list.files(path = home_dir, pattern = "reference\\.fasta", full.names = TRUE)
#output_dir
output_dir <- home_dir

#create subsampled reads directory
if (!dir.exists(paste0(home_dir, "/subsampled_reads"))) {
  dir.create(paste0(home_dir, "/subsampled_reads"))
}

#subsample reads
if (length(list.files(path = paste0(home_dir, "/subsampled_reads"), pattern = paste0(X, "_reads_subset_.+\\.fastq"))) == 0) {
  for (i in 1:K) {
    system(command = paste0(SEQTK, " sample -s ", i, " ", fastq_reads_file, " ", X, " > ", home_dir, "/subsampled_reads/", X, "_reads_subset_", i, ".fastq"))
  }
}

#perform read alignment and phasing for each subset
output_dir_curr_X <- paste0(output_dir, "/", X, "_reads_subsets_", aligner, "_", phaser)
if (!dir.exists(output_dir_curr_X)) {
  dir.create(output_dir_curr_X)
  for (i in 1:K) {
    dir.create(paste0(output_dir_curr_X, "/", X, "_reads_subset_", i))
    subset_reads_curr_iteration <- paste0(output_dir_curr_X, "/", X, "_reads_subset_", i, "/reads.fastq")
    system(command = paste0("ln -s ", home_dir, "/subsampled_reads/", X, "_reads_subset_", i, ".fastq", " ", subset_reads_curr_iteration))
    output_dir_curr_iteration <- paste0(output_dir_curr_X, "/", X, "_reads_subset_", i)
    system(command = paste0(phase_reads, " ", subset_reads_curr_iteration, " ", reference_seq, " ", aligner, " ", phaser, " ", unphased_VCF_file, " ", output_dir_curr_iteration, " ", combine_phasers))
  }
}

#evaluate phasing
if (phaser == "HapCUT2") {
  pattern_vcf <- "phased_hapcut2_output\\.vcf$"
} elif (phaser == "whatshap") {
  pattern_vcf <- "phased_whatshap_output\\.vcf$"
} else
  pattern_vcf <- "phased_hapchat_output\\.vcf$"
fi


#consensus phasing
phased_VCF_files <- list.files(path = output_dir_curr_X, recursive = TRUE, pattern = pattern_vcf, ignore.case = TRUE, full.names = TRUE)
haplotype_consensus_chr <- combine_iterations(unphased_VCF_file, phased_VCF_files)
