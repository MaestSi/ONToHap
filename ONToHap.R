#
# Copyright 2020 Simone Maestri. All rights reserved.
# Simone Maestri <simone.maestri@univr.it>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

args = commandArgs(trailingOnly=TRUE)

PIPELINE_DIR <- dirname(strsplit(commandArgs(trailingOnly = FALSE)[4],"=")[[1]][2])
CONFIG_FILE <- paste0(PIPELINE_DIR, "/config_ONToHap.R")
source(CONFIG_FILE)
source(combine_iterations)

#fastq reads
fastq_reads_file = args[1]
#unphased VCF file
unphased_VCF_file = args[2]
#reference sequence
reference_seq = args[3]
#output_dir
output_dir_base = args[4]
sample_name <- sub(pattern = "(.*)\\..*$", replacement = "\\1", basename(fastq_reads_file))
output_dir <- paste0(output_dir_base, "/", sample_name, "_ONToHap_results")

#create output directory
if (!dir.exists(output_dir)) {
  dir.create(output_dir)
}

#create subsampled reads directory
if (!dir.exists(paste0(output_dir, "/subsampled_reads"))) {
  dir.create(paste0(output_dir, "/subsampled_reads"))
}

#subsample reads
if (length(list.files(path = paste0(output_dir, "/subsampled_reads"), pattern = paste0(X, "_reads_subset_.+\\.fastq"))) == 0) {
  for (i in 1:K) {
    system(command = paste0(SEQTK, " sample -s ", i, " ", fastq_reads_file, " ", X, " > ", output_dir, "/subsampled_reads/", X, "_reads_subset_", i, ".fastq"))
  }
}

#perform read alignment and phasing for each subset
output_dir_curr_X <- paste0(output_dir, "/", X, "_reads_subsets_", aligner, "_", phaser)
if (!dir.exists(output_dir_curr_X)) {
  dir.create(output_dir_curr_X)
  for (i in 1:K) {
    dir.create(paste0(output_dir_curr_X, "/", X, "_reads_subset_", i))
    subset_reads_curr_iteration <- paste0(output_dir_curr_X, "/", X, "_reads_subset_", i, "/reads.fastq")
    system(command = paste0("ln -s ", output_dir, "/subsampled_reads/", X, "_reads_subset_", i, ".fastq", " ", subset_reads_curr_iteration))
    output_dir_curr_iteration <- paste0(output_dir_curr_X, "/", X, "_reads_subset_", i)
    system(command = paste0(phase_reads, " ", subset_reads_curr_iteration, " ", reference_seq, " ", aligner, " ", phaser, " ", unphased_VCF_file, " ", output_dir_curr_iteration, " ", combine_phasers, " ", two_steps_flag))
  }
}

#consensus phasing
if (length(grep("HapCUT2", phaser, ignore.case=TRUE)) != 0) {
  pattern_vcf <- "phased_hapcut2_output\\.vcf$"
} else if (length(grep("Whatshap", phaser, ignore.case=TRUE)) != 0) {
  pattern_vcf <- "phased_whatshap_output\\.vcf$"
} else if (length(grep("HAPCHAT", phaser, ignore.case=TRUE)) != 0) {
  pattern_vcf <- "phased_hapchat_output\\.vcf$"
}

phased_VCF_files <- list.files(path = output_dir_curr_X, recursive = TRUE, pattern = pattern_vcf, ignore.case = TRUE, full.names = TRUE)
haplotype_consensus_chr <- combine_iterations(unphased_VCF_file, phased_VCF_files)
