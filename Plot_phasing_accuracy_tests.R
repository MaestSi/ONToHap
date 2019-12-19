#install.packages("ggplot2")
require(ggplot2)
num_subsamplings <- 1000
num_reads <- c(10, 100, 1000, 10000)
num_reads_rep <- rep(x = num_reads, times = 4)

#Sample S1
n_phased_var <- 18
ind_indels <- c(1, 12, 18)
#Minimap2_HapCUT2
mean_accuracy_minimap_hapcut <- c(72.322, 92.906, 96.382, 99.165)
stdev_minimap_hapcut <- c(16.357, 5.136, 4.038, 2.054)
mean_accuracy_by_pos_minimap_hapcut <- matrix(data = NA, nrow = length(num_reads), ncol = n_phased_var)
#10 reads
mean_accuracy_by_pos_minimap_hapcut[1, ] <- c(15.2, 81.2, 76.9, 77.4, 76.8, 83, 66.4, 82.8, 39, 90.3, 84.4, 21.8, 83.9, 87.5, 85.2, 82.7, 90.8, 76.5)
#100 reads
mean_accuracy_by_pos_minimap_hapcut[2, ] <- c(52.7, 99.8, 99.6, 100, 99.8, 100, 99, 100, 68.5, 100, 99.9, 60.8, 100, 100, 100, 100, 100, 99.3)
#1000 reads
mean_accuracy_by_pos_minimap_hapcut[3, ] <- c(66.8, 100, 100, 100, 100, 100, 100, 100, 92.5, 100, 100, 79.2, 100, 100, 100, 100, 100, 100)
#10000 reads
mean_accuracy_by_pos_minimap_hapcut[4, ] <- c(86.2, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 99.6, 100, 100, 100, 100, 100, 100)
#Full haplotype
mean_accuracy_full_hap_minimap_hapcut <- c(0.500, 22.400, 49.700, 85.800)

#BWA_HapCUT2
mean_accuracy_bwa_hapcut <- c(72.361, 92.959, 96.459, 99.053)
stdev_bwa_hapcut <- c(16.133, 5.036, 3.999, 2.163)
mean_accuracy_by_pos_bwa_hapcut <- matrix(data = NA, nrow = length(num_reads), ncol = n_phased_var)
mean_accuracy_by_pos_bwa_hapcut[1, ] <- c(14.8, 79.8, 76.4, 77.3, 75.8, 83.9, 67.1, 82.4, 40.4, 90.2, 84, 21.8, 84.4, 87.7, 86.2, 83.4, 90.5, 76.4)
mean_accuracy_by_pos_bwa_hapcut[2, ] <- c(51.3, 99.8, 99.5, 99.9, 99.8, 100, 99.3, 100, 71.1, 100, 100, 60.3, 100, 100, 100, 100, 100, 99.3)
mean_accuracy_by_pos_bwa_hapcut[3, ] <- c(66, 100, 100, 100, 100, 100, 100, 100, 95.2, 100, 100, 78.6, 100, 100, 100, 100, 100, 100)
mean_accuracy_by_pos_bwa_hapcut[4, ] <- c(84.2, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 99.7, 100, 100, 100, 100, 100, 100)
mean_accuracy_full_hap_bwa_hapcut <- c(0.700, 21.500, 50.400, 83.900)

#Minimap2_Whatshap two-step enable real step 1
mean_accuracy_minimap_whatshap <- c(77.17, 97.16, 99.04, 99.51)
stdev_minimap_whatshap <- c(15.66, 4.78, 3.17, 2.23)
mean_accuracy_by_pos_minimap_whatshap <- matrix(data = NA, nrow = length(num_reads), ncol = n_phased_var)
mean_accuracy_by_pos_minimap_whatshap[1, ] <- c(46.86, 81.51, 79.89, 78.58, 79.39, 86.36, 78.78, 86.76, 62.12, 92.92, 87.87, 51.31, 86.26, 90.30, 88.48, 84.94, 90.20, 59.29)
mean_accuracy_by_pos_minimap_whatshap[2, ] <- c(88.8, 98.7, 97.5, 98.7, 98.9, 99.7, 96.5, 99.9, 88.3, 100, 99.9, 89.1, 99.7, 99.8, 99.8, 99.9, 99.8, 96.7)
mean_accuracy_by_pos_minimap_whatshap[3, ] <- c(99.9, 98.3, 98.1, 99, 99.1, 99.9, 97.9, 100, 93.2, 100, 100, 98.9, 99.9, 99.9, 99.8, 99.9, 99.9, 100)
mean_accuracy_by_pos_minimap_whatshap[4, ] <- c(100, 98.6, 99.1, 99.5, 99.3, 100, 99.5, 100, 97.1, 100, 99.9, 99.3, 100, 100, 99.7, 99.7, 100, 100)
mean_accuracy_full_hap_minimap_whatshap <- c(6.36, 64.60, 87.70, 93.70)

#BWA_Whatshap 2step enable real step 1
mean_accuracy_bwa_whatshap <- c(76.65, 96.86, 98.91, 99.29)
stdev_bwa_whatshap <- c(16.06, 5.35, 2.98, 2.66)
mean_accuracy_by_pos_bwa_whatshap <- matrix(data = NA, nrow = length(num_reads), ncol = n_phased_var)
mean_accuracy_by_pos_bwa_whatshap[1, ] <- c(50.25, 80.14, 76.73, 76.42, 77.33, 85.25, 76.32, 85.25, 63.79, 92.57, 86.86, 49.54, 86.55, 91.17, 87.76, 87.06, 90.07, 59.87)
mean_accuracy_by_pos_bwa_whatshap[2, ] <- c(90.9, 98.4, 96.6, 98.1, 98.3, 99.6, 95.8, 99.7, 84.8, 99.9, 99.7, 89, 99.7, 99.9, 99.8, 99.7, 99.9, 96.9)
mean_accuracy_by_pos_bwa_whatshap[3, ] <- c(99.8, 98.3, 98.2, 99.3, 99.2, 100, 97.7, 99.9, 92, 100, 100, 97.5, 99.8, 100, 99.9, 100, 99.9, 100)
mean_accuracy_by_pos_bwa_whatshap[4, ] <- c(100, 98.0, 98.6, 99.5, 99.7, 99.8, 98.6, 100, 95.5, 100, 100, 98.5, 100, 100, 99.8, 99.9, 99.9, 100)
mean_accuracy_full_hap_bwa_whatshap <- c(6.32, 63.6, 85.1, 90.9)

#store in dataframe
mean_accuracy <- c(mean_accuracy_minimap_hapcut, mean_accuracy_bwa_hapcut, mean_accuracy_minimap_whatshap, mean_accuracy_bwa_whatshap)
sd <- c(stdev_minimap_hapcut, stdev_bwa_hapcut, stdev_minimap_whatshap, stdev_bwa_whatshap)
mean_accuracy_full_hap <- c(mean_accuracy_full_hap_minimap_hapcut, mean_accuracy_full_hap_bwa_hapcut, mean_accuracy_full_hap_minimap_whatshap, mean_accuracy_full_hap_bwa_whatshap)
groups <- c(rep(x = "Minimap2_HapCUT2", times = length(num_reads)), rep(x = "BWA_HapCUT2", times = length(num_reads)), rep(x = "Minimap2_Whatshap_two-step", times = length(num_reads)), rep(x = "BWA_Whatshap_two-step", times = length(num_reads)))
df <- data.frame(num_reads_rep, mean_accuracy, sd, mean_accuracy_full_hap, groups)

# Plot accuracy of phased variants
ggplot(df, aes(x = num_reads_rep, y = mean_accuracy, group = groups, color = groups, shape = groups)) + 
  geom_point(size = 3) + geom_line(size = 1) + 
  geom_errorbar(aes(x=num_reads_rep, ymin=mean_accuracy - sd, ymax=mean_accuracy + sd), width = 0.25, size = 1) +
  labs(title="Mean accuracy of phased variants - S1",x="Number of subsampled reads", y = "%Properly phased variants") +
  ylim(0, 110) + theme_minimal() + scale_x_log10(breaks = scales::trans_breaks("log10", function(x) 10^x),
                                                 labels = scales::trans_format("log10", scales::math_format(10^.x))) +
  annotation_logticks(sides = "b")


# Plot accuracy of fully reconstructed haplotype

#jpeg(filename = "C:\\Users/SimoneMaestri/Desktop/S1_full_haplotype.jpeg",
#     width = 600, height = 600, units = "px", pointsize = 12,
#     quality = 100,
#     bg = "white")

ggplot(df, aes(x = num_reads_rep, y = mean_accuracy_full_hap, color = groups, shape = groups)) + 
  geom_point(size = 3) + geom_line(size = 1.2) + ylim(0, 110) +
  labs(title="",x="Number of subsampled reads", y = "Properly phased haplotypes (%times)") +
  theme(legend.justification = c(1, 0), legend.position = c(1, 0), legend.box.margin=margin(c(10,10,10,10)),
        legend.title = element_blank(), panel.background = element_blank(), axis.line = element_line(),
        text=element_text(size=15)) +
  scale_colour_discrete(labels = c("BWA + HapCUT2", "BWA + Whatshap", "Minimap2 + HapCUT2", "Minimap2 + Whatshap")) +
  scale_shape_discrete(labels = c("BWA + HapCUT2", "BWA + Whatshap", "Minimap2 + HapCUT2", "Minimap2 + Whatshap")) +
  scale_x_log10(breaks = scales::trans_breaks("log10", function(x) 10^x, n = 4),
                labels = scales::trans_format("log10", scales::math_format(10^.x))) +
  annotation_logticks(sides = "b")
#dev.off()

## Plot accuracy by position
#xlabels <- c("4251", "5501", "6341", "6549", "6880", "9792", "10946", "11289", "11648", "12112", "12164", "12579", "13353", "13891", "14191", "14454", "14544", "15351")
xlabels <- c("rs34215622", "rs7259620", "rs769446", "rs405509", "rs440446", "rs7412", "rs1065853", "rs75627662", "rs72654469", "rs72654473", "rs439401", "rs58282242", "rs445925", "rs483082", "rs584007", "rs438811", "rs390082", "rs34954997")
xlabels_colours <- rep(x = "black", times = length(xlabels))
#xlabels_colours[ind_indels] <- "red"
xlabels_colours[c(1, 9, 12)] <- "red"

for (nr_ind in 1:length(num_reads)) {
  n_phased_var_by_pos <- rep(x = 1:n_phased_var, times = 4)
  mean_accuracy_by_pos <- rbind(mean_accuracy_by_pos_minimap_hapcut[nr_ind, ], mean_accuracy_by_pos_bwa_hapcut[nr_ind, ], mean_accuracy_by_pos_minimap_whatshap[nr_ind, ], mean_accuracy_by_pos_bwa_whatshap[nr_ind, ])
  mean_accuracy_by_pos_vec <- as.vector(t(mean_accuracy_by_pos))
  groups_by_pos <- c(rep(x = "Minimap2_HapCUT2", times = n_phased_var), rep(x = "BWA_HapCUT2", times = n_phased_var), rep(x = "Minimap2_Whatshap", times = n_phased_var), rep(x = "BWA_Whatshap", times = n_phased_var))
  df_by_pos <- data.frame(n_phased_var_by_pos, mean_accuracy_by_pos_vec, groups_by_pos)
  #png(filename = paste0("C:\\Users/SimoneMaestri/Desktop/S1_accuracy_by_pos_", num_reads[nr_ind],"reads.jpeg"))#,
  #width = 600, height = 600, units = "px", pointsize = 12, quality = 100, bg = "white")
  ggplot(df_by_pos, aes(x = n_phased_var_by_pos, y = mean_accuracy_by_pos_vec, group = groups_by_pos, color = groups_by_pos, shape = groups_by_pos)) +
    geom_point(size = 3) +
    geom_vline(xintercept=1:n_phased_var, linetype = "dotted") +
    labs(title=paste0("Mean accuracy by position - S1 - ", num_reads[nr_ind], " reads"), x="Number of subsampled reads", y = "Properly phased variants (%times)") +
    ylim(0, 100) +
    theme(axis.text.x = element_text(angle = 90, size = 10, colour = xlabels_colours, vjust = 0.5), legend.title = element_blank(), panel.background = element_blank(), axis.line = element_line(),
          text=element_text(size=15)) + 
    scale_x_discrete(name ="dbSNP ID", limits = xlabels) +
    scale_colour_discrete(labels = c("BWA + HapCUT2", "BWA + Whatshap", "Minimap2 + HapCUT2", "Minimap2 + Whatshap")) +
    scale_shape_discrete(labels = c("BWA + HapCUT2", "BWA + Whatshap", "Minimap2 + HapCUT2", "Minimap2 + Whatshap"))
  #dev.off()
}