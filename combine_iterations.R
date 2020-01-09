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

combine_iterations <- function(unphased_VCF_file, phased_VCF_files) {
  unphased_VCF <- read.table(file = unphased_VCF_file, stringsAsFactors = FALSE)
  ind_het <- grep(x = unphased_VCF[, 10], pattern = "0/1")
  pos_het <- unphased_VCF[ind_het, 2]
  
  phased_het <- matrix(data = NA, nrow = length(phased_VCF_files), ncol = length(ind_het))
  
  for (i in 1:length(phased_VCF_files)) {
    curr_VCF <- read.table(file = phased_VCF_files[i], stringsAsFactors = FALSE, sep = "\t")
    ind_phased_het <- grep(x = curr_VCF[, 10], pattern = "0/1|0\\|1|1\\|0")
    phased_het_curr <- substr(x = curr_VCF[ind_phased_het, 10], start = 1, stop = 3)
    
    phased_chr_tmp1 <- gsub(pattern = "0\\|1", replacement = 1, x = phased_het_curr)
    phased_chr_tmp2 <- gsub(pattern = "1\\|0", replacement = 2, x = phased_chr_tmp1)
    phased_chr <- as.numeric(gsub(pattern = "0/1", replacement = 0, x = phased_chr_tmp2))
    
    phased_chr_compl <- phased_chr
    phased_chr_compl[which(phased_chr_compl == 1)] <- 3
    phased_chr_compl[which(phased_chr_compl == 2)] <- 1
    phased_chr_compl[which(phased_chr_compl == 3)] <- 2
    
    if (i == 1) {
      phased_het[1, ] <- phased_chr
    } else {
      num_matches <- length(which(phased_het[1, ] == phased_chr))
      num_matches_compl <- length(which(phased_het[1, ] == phased_chr_compl))
      if (num_matches >= num_matches_compl) {
        phased_het[i, ] <- phased_chr
      } else {
        phased_het[i, ] <- phased_chr_compl
      }
    } 
  }
 
  haplotype_consensus <- vector(length = length(ind_het))
  for (i in 1:length(ind_het)) {
    haplotype_consensus[i] <- as.numeric(names(which.max(table(phased_het[, i]))))
  }

  haplotype_consensus_chr <- matrix(data = NA, nrow = length(haplotype_consensus), ncol = 1)
  ind_indet <- which(haplotype_consensus == 0)
  ind_0_1 <- which(haplotype_consensus == 1)
  ind_1_0 <- which(haplotype_consensus == 2)

  haplotype_consensus_chr[ind_indet] <- "0/1"
  haplotype_consensus_chr[ind_0_1] <- "0|1"
  haplotype_consensus_chr[ind_1_0] <- "1|0"

  consensus_VCF <- unphased_VCF  
  
  consensus_VCF[, 9] <- "GT"
  consensus_VCF[, 10] <- unlist(lapply(strsplit(x = consensus_VCF[, 10], split = ":"), `[[`, 1))

  consensus_VCF[ind_het[ind_0_1], 10] <- "0|1"
  consensus_VCF[ind_het[ind_1_0], 10] <- "1|0"

  header <- c("#CHROM", "POS", "ID", "REF", "ALT", "QUAL", "FILTER", "INFO", "FORMAT", "")
  consensus_VCF <- rbind(header, consensus_VCF)
  consensus_VCF_file <- paste0(dirname(dirname(dirname(phased_VCF_files[1]))), "/consensus_haplotype.vcf")
  write.table(x = consensus_VCF, file = consensus_VCF_file, quote = FALSE, row.names = FALSE, sep = "\t", col.names = FALSE)
  return(haplotype_consensus_chr) 
}
