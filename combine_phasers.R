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

VCF_file_no_indels <- args[1] 
VCF_file_with_indels <- args[2]

VCF_no_indels <- read.table(file = VCF_file_no_indels, stringsAsFactors = FALSE)
VCF_with_indels <- read.table(file = VCF_file_with_indels, stringsAsFactors = FALSE)

ind_header <- grep(x = readLines(con = VCF_file_with_indels), pattern = "^#")
header <- readLines(con = VCF_file_with_indels)[ind_header]

ref_nt <- VCF_with_indels[, 4]
alt_nt <- VCF_with_indels[, 5]

ind_phased_het <- grep(x = VCF_with_indels[, 10], pattern = "0/1|0\\|1|1\\|0")

VCF_no_indels_phased_het <- substr(x = VCF_no_indels[ind_phased_het, 10], start = 1, stop = 3)
VCF_no_indels_phased_chr_tmp1 <- gsub(pattern = "0\\|1", replacement = 1, x = VCF_no_indels_phased_het)
VCF_no_indels_phased_chr_tmp2 <- gsub(pattern = "1\\|0", replacement = 2, x = VCF_no_indels_phased_chr_tmp1)
VCF_no_indels_phased_chr <- as.numeric(gsub(pattern = "0/1", replacement = 0, x = VCF_no_indels_phased_chr_tmp2))

ind_indel <- which(nchar(ref_nt[ind_phased_het]) != nchar(alt_nt[ind_phased_het]))

VCF_indels_phased_het <- substr(x = VCF_with_indels[ind_phased_het, 10], start = 1, stop = 3)
VCF_indels_phased_chr_tmp1 <- gsub(pattern = "0\\|1", replacement = 1, x = VCF_indels_phased_het)
VCF_indels_phased_chr_tmp2 <- gsub(pattern = "1\\|0", replacement = 2, x = VCF_indels_phased_chr_tmp1)
VCF_indels_phased_chr <- as.numeric(gsub(pattern = "0/1", replacement = 0, x = VCF_indels_phased_chr_tmp2))

VCF_indels_phased_chr_compl <- VCF_indels_phased_chr
VCF_indels_phased_chr_compl[which(VCF_indels_phased_chr_compl == 1)] <- 3
VCF_indels_phased_chr_compl[which(VCF_indels_phased_chr_compl == 2)] <- 1
VCF_indels_phased_chr_compl[which(VCF_indels_phased_chr_compl == 3)] <- 2

nmatches <- length(which(VCF_indels_phased_chr == VCF_no_indels_phased_chr))
nmatches_compl <- length(which(VCF_indels_phased_chr_compl == VCF_no_indels_phased_chr))

if (nmatches >= nmatches_compl) {
  VCF_indels_phased_chr_corr <- VCF_indels_phased_chr
  VCF_indels_phased_het_corr <- VCF_indels_phased_het
} else {
  VCF_indels_phased_chr_corr <- VCF_indels_phased_chr_compl
  VCF_indels_phased_het_corr <- VCF_indels_phased_het
  tmp1 <- gsub(pattern = "0\\|1", replacement = "tmp", x = VCF_indels_phased_het_corr)
  tmp2 <- gsub(pattern = "1\\|0", replacement = "0|1", x = tmp1)
  VCF_indels_phased_het_corr <- gsub(pattern = "tmp", replacement = "1|0", x = tmp2)
}

ind_disc <- which(VCF_indels_phased_chr_corr != VCF_no_indels_phased_chr)

ind_disc_indel <- intersect(ind_disc, ind_indel)

if (length(which(VCF_no_indels_phased_chr[ind_disc] == 0)) > 0) {
  ind_VCF_no_indels_indet <- which(VCF_no_indels_phased_chr[ind_disc] == 0)
  ind_sub <- sort(unique(c(ind_disc_indel, ind_disc[ind_VCF_no_indels_indet])))
}
combined_VCF <- VCF_no_indels
combined_VCF[, 9] <- "GT"
combined_VCF[, 10] <- unlist(lapply(strsplit(x = VCF_no_indels[, 10], split = ":"), `[[`, 1))

if (exists("ind_sub")) {
  if (length(ind_sub) > 0) {
    combined_VCF[ind_phased_het[ind_sub], 10] <- VCF_indels_phased_het_corr[ind_sub]
  }
}

combined_VCF_file <- paste0(dirname(VCF_file_with_indels), "/phased_whatshap_output.vcf")
write.table(x = header, file = combined_VCF_file, quote = FALSE, row.names = FALSE, sep = "\t", col.names = FALSE)
write.table(x = combined_VCF, file = combined_VCF_file, quote = FALSE, row.names = FALSE, sep = "\t", col.names = FALSE, append = TRUE)
