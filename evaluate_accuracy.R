#
# Copyright 2019 Simone Maestri. All rights reserved.
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

evaluate_accuracy <- function(unphased_VCF_file, reference_VCF_file, phased_VCF_files, logfile){
  unphased_VCF <- read.table(file = unphased_VCF_file, stringsAsFactors = FALSE)
  ind_het <- grep(x = unphased_VCF[, 10], pattern = "0/1")
  pos_het <- unphased_VCF[ind_het, 2]
  
  reference_VCF <- read.table(file = reference_VCF_file, stringsAsFactors = FALSE)
  ref_ind_phased_het <- grep(x = reference_VCF[, 10], pattern = "0/1|0\\|1|1\\|0")
  ref_phased_het <- reference_VCF[ref_ind_phased_het, 10]
  
  reference_phased_chr_tmp1 <- gsub(pattern = "0\\|1", replacement = 1, x = ref_phased_het)
  reference_phased_chr_tmp2 <- gsub(pattern = "1\\|0", replacement = 2, x = reference_phased_chr_tmp1)
  reference_phased_chr <- as.numeric(gsub(pattern = "0/1", replacement = 0, x = reference_phased_chr_tmp2))
  
  ind_no_cfr <- which(reference_phased_chr == 0)
  ind_cfr <- setdiff(1:length(reference_phased_chr), ind_no_cfr)
  
  full_phased_het <- matrix(data = NA, nrow = length(phased_VCF_files), ncol = length(ind_het))
  
  for (i in 1:length(phased_VCF_files)) {
    curr_VCF <- read.table(file = phased_VCF_files[i], stringsAsFactors = FALSE, sep = "\t")
    ind_phased_het <- grep(x = curr_VCF[, 10], pattern = "0/1|0\\|1|1\\|0")
    phased_het <- substr(x = curr_VCF[ind_phased_het, 10], start = 1, stop = 3)
    
    phased_chr_tmp1 <- gsub(pattern = "0\\|1", replacement = 1, x = phased_het)
    phased_chr_tmp2 <- gsub(pattern = "1\\|0", replacement = 2, x = phased_chr_tmp1)
    phased_chr <- as.numeric(gsub(pattern = "0/1", replacement = 0, x = phased_chr_tmp2))
    
    phased_chr_compl <- phased_chr
    phased_chr_compl[which(phased_chr_compl == 1)] <- 3
    phased_chr_compl[which(phased_chr_compl == 2)] <- 1
    phased_chr_compl[which(phased_chr_compl == 3)] <- 2
    
    num_matches <- length(which(reference_phased_chr[ind_cfr] == phased_chr[ind_cfr]))
    num_matches_compl <- length(which(reference_phased_chr[ind_cfr] == phased_chr_compl[ind_cfr]))
    
    if (num_matches >= num_matches_compl) {
      full_phased_het[i, ] <- phased_chr
    } else {
      full_phased_het[i, ] <- phased_chr_compl
    }
  }
  
  consensus_phase <- vector(length = length(ind_het))
  for (i in 1:length(ind_het)) {
    consensus_phase[i] <- as.numeric(names(which.max(table(full_phased_het[, i]))))
  }
  
  consensus_matches <- length(which(consensus_phase[ind_cfr] == reference_phased_chr[ind_cfr]))
  
  num_errors_by_pos <- vector(length = length(ind_cfr))
  
  for (i in 1:length(ind_cfr)) {
    num_errors_by_pos[i] <- length(which(full_phased_het[, ind_cfr[i]] != reference_phased_chr[ind_cfr[i]]))
  }
  
  accuracy_by_pos <- 100 - 100*num_errors_by_pos/length(phased_VCF_files)
  #accuracy <- 100 - sum(100 - acc_by_pos)/(length(ind_cfr)- 1)
  accuracy <- 100 - 100*sum(num_errors_by_pos)/(length(phased_VCF_files)*(length(ind_cfr) - 1))
   
  counter_acc <- 0

  for (i in 1:nrow(full_phased_het)) {
    if (isTRUE(all.equal(full_phased_het[i, ind_cfr], reference_phased_chr[ind_cfr]))) {
      counter_acc <- counter_acc + 1
    }
  }
  accuracy_full_haplotype <- 100*counter_acc/nrow(full_phased_het)

  accuracy_row <- vector(length = dim(full_phased_het)[1])
  for (i in 1:length(accuracy_row)) {
    accuracy_row[i] <- 100 - 100*length(which(full_phased_het[i, ind_cfr] != reference_phased_chr[ind_cfr]))/(length(ind_cfr) - 1)
  }
  
  stdev <- sd(accuracy_row)
  
  write(sprintf("Mean accuracy at variant level: %.3f%%\n", accuracy), file = logfile)
  write(sprintf("Standard deviation of accuracy at variant level: %.3f%%\n", stdev), file = logfile, append = TRUE)
  write(sprintf("Mean accuracy split by variant: %s%%\n", paste0(accuracy_by_pos, collapse = "%, ")), file = logfile, append = TRUE)
  write(sprintf("Mean accuracy at full haplotype level: %.3f%%\n", accuracy_full_haplotype), file = logfile, append = TRUE)  
  
  return(full_phased_het) 
}
