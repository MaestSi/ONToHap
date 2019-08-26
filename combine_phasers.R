args = commandArgs(trailingOnly=TRUE)

vcf_file_no_indels <- args[1] 
vcf_file_with_indels <- args[2]

vcf_no_indels <- read.table(file = vcf_file_no_indels, stringsAsFactors = FALSE)
vcf_with_indels <- read.table(file = vcf_file_with_indels, stringsAsFactors = FALSE)

ind_header <- grep(x = readLines(con = vcf_file_with_indels), pattern = "^##")
header <- readLines(con = vcf_file_with_indels)[ind_header]

ref_nt <- vcf_with_indels[, 4]
alt_nt <- vcf_with_indels[, 5]

ind_phased_het <- grep(x = vcf_with_indels[, 10], pattern = "0/1|0\\|1|1\\|0")

vcf_no_indels_phased_het <- substr(x = vcf_no_indels[ind_phased_het, 10], start = 1, stop = 3)
vcf_no_indels_phased_chr_tmp1 <- gsub(pattern = "0\\|1", replacement = 1, x = vcf_no_indels_phased_het)
vcf_no_indels_phased_chr_tmp2 <- gsub(pattern = "1\\|0", replacement = 2, x = vcf_no_indels_phased_chr_tmp1)
vcf_no_indels_phased_chr <- as.numeric(gsub(pattern = "0/1", replacement = 0, x = vcf_no_indels_phased_chr_tmp2))

ind_indel <- which(nchar(ref_nt[ind_phased_het]) != nchar(alt_nt[ind_phased_het]))

vcf_indels_phased_het <- substr(x = vcf_with_indels[ind_phased_het, 10], start = 1, stop = 3)
vcf_indels_phased_chr_tmp1 <- gsub(pattern = "0\\|1", replacement = 1, x = vcf_indels_phased_het)
vcf_indels_phased_chr_tmp2 <- gsub(pattern = "1\\|0", replacement = 2, x = vcf_indels_phased_chr_tmp1)
vcf_indels_phased_chr <- as.numeric(gsub(pattern = "0/1", replacement = 0, x = vcf_indels_phased_chr_tmp2))

vcf_indels_phased_chr_compl <- vcf_indels_phased_chr
vcf_indels_phased_chr_compl[which(vcf_indels_phased_chr_compl == 1)] <- 3
vcf_indels_phased_chr_compl[which(vcf_indels_phased_chr_compl == 2)] <- 1
vcf_indels_phased_chr_compl[which(vcf_indels_phased_chr_compl == 3)] <- 2

nmatches <- length(which(vcf_indels_phased_chr == vcf_no_indels_phased_chr))
nmatches_compl <- length(which(vcf_indels_phased_chr_compl == vcf_no_indels_phased_chr))

if (nmatches >= nmatches_compl) {
  vcf_indels_phased_chr_corr <- vcf_indels_phased_chr
  vcf_indels_phased_het_corr <- vcf_indels_phased_het
} else {
  vcf_indels_phased_chr_corr <- vcf_indels_phased_chr_compl
  vcf_indels_phased_het_corr <- vcf_indels_phased_het
  tmp1 <- gsub(pattern = "0\\|1", replacement = "tmp", x = vcf_indels_phased_het_corr)
  tmp2 <- gsub(pattern = "1\\|0", replacement = "0|1", x = tmp1)
  vcf_indels_phased_het_corr <- gsub(pattern = "tmp", replacement = "1|0", x = tmp2)
}

ind_disc <- which(vcf_indels_phased_chr_corr != vcf_no_indels_phased_chr)

ind_disc_indel <- intersect(ind_disc, ind_indel)

if (length(which(vcf_no_indels_phased_chr[ind_disc] == 0)) > 0) {
  ind_vcf_no_indels_indet <- which(vcf_no_indels_phased_chr[ind_disc] == 0)
  ind_sub <- sort(unique(c(ind_disc_indel, ind_disc[ind_vcf_no_indels_indet])))
}
combined_vcf <- vcf_no_indels
combined_vcf[, 9] <- "GT"
combined_vcf[, 10] <- unlist(lapply(strsplit(x = vcf_no_indels[, 10], split = ":"), `[[`, 1))

if (exists("ind_sub")) {
  if (length(ind_sub) > 0) {
    combined_vcf[ind_phased_het[ind_sub], 10] <- vcf_indels_phased_het_corr[ind_sub]
  }
}

header_fixed <- paste0(c("#CHROM", "POS", "ID", "REF", "ALT", "QUAL", "FILTER", "INFO", "FORMAT", ""), collapse = "    ")
header_full <- c(header, header_fixed)
combined_vcf <- rbind(header_full, combined_vcf)
combined_vcf_file <- paste0(dirname(vcf_file_with_indels), "/phased_whatshap_output.vcf")
write.table(x = combined_vcf, file = combined_vcf_file, quote = FALSE, row.names = FALSE, sep = "\t", col.names = FALSE)
