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
#SEQTK
SEQTK <- "seqtk"
#PIPELINE DIR
PIPELINE_DIR <- "/path/to/ONToHap"
############ End of user editable region #################################################################
#phase_reads.sh
phase_reads <- paste0(PIPELINE_DIR, "/phase_reads.sh")
#combine_iterations.R
combine_iterations <- paste0(PIPELINE_DIR, "/combine_iterations.R")
#combine_phasers
combine_phasers <- paste0(PIPELINE_DIR, "/combine_phasers.R")
#evaluate_accuracy
evaluate_accuracy <- paste0(PIPELINE_DIR, "/evaluate_accuracy.R")
##########################################################################################################
