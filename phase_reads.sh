#!/bin/bash

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

fastq_reads=$1
reference=$2
aligner=$3
phaser=$4
unphased_vcf=$5
output_dir=$6
combine_phasers=$7

PIPELINE_DIR=$(realpath $( dirname "${BASH_SOURCE[0]}" ))
source $PIPELINE_DIR"/tools.sh"

#choose if performing phasing in 2 steps or 1 step when using Whatshap
two_steps=FALSE
#two_steps=TRUE

$SAMTOOLS faidx $reference
fasta_reads=$(sed "s/\\.fastq/\\.fasta/g" <<< $fastq_reads)
aligner_uc=$(awk '{print toupper($0)'} <<< $aligner)
phaser_uc=$(awk '{print toupper($0)'} <<< $phaser)
cat $reference | sed '/^[^>]/ y/acgtn/ACGTN/' > $output_dir/reference_uc.fasta
$SAMTOOLS faidx $output_dir/reference_uc.fasta

if [ "$aligner_uc" == "BWA" ]; then
  #read mapping with BWA
  $BWA index $output_dir/reference_uc.fasta
  $BWA mem -x ont2d -t 30 $output_dir/reference_uc.fasta $fastq_reads | samtools view -h -F 2048 | samtools sort -o $output_dir/reads.filter.sorted.bam -T reads.tmp
elif [ "$aligner_uc" == "MINIMAP2" ]; then
  #read mapping with Minimap2
  #$SEQTK seq -A $fastq_reads > $fasta_reads
  #$MINIMAP2 -ax map-ont $reference $fasta_reads | $SAMTOOLS view -h -F 2048 | $SAMTOOLS sort -o $output_dir/reads.filter.sorted.bam -T reads.tmp
  $MINIMAP2 -ax map-ont $output_dir/reference_uc.fasta $fastq_reads | $SAMTOOLS view -h -F 2048 | $SAMTOOLS sort -o $output_dir/reads.filter.sorted.bam -T reads.tmp
else
  echo "Aligner $aligner is not supported (choose between BWA and Minimap2)"
  exit
fi

$SAMTOOLS index $output_dir/reads.filter.sorted.bam

if [ "$phaser_uc" == "WHATSHAP" ]; then
  if [ "two_steps" == "TRUE" ]; then
  #phasing with Whatshap 2 step (enable realignment only for step 1)
  $WHATSHAP phase $unphased_vcf $output_dir/reads.filter.sorted.bam -o $output_dir/phased_whatshap_output_no_indels.vcf --ignore-read-groups --tag=PS --reference $output_dir/reference_uc.fasta --algorithm whatshap
  $WHATSHAP phase $unphased_vcf $output_dir/reads.filter.sorted.bam -o $output_dir/phased_whatshap_output_with_indels.vcf --ignore-read-groups --indels --tag=PS --algorithm whatshap
  #combine phasing software's outputs
  $RSCRIPT $combine_phasers $output_dir/phased_whatshap_output_no_indels.vcf $output_dir/phased_whatshap_output_with_indels.vcf
  else
  #enable realignment only 1 step
  $WHATSHAP phase $unphased_vcf $output_dir/reads.filter.sorted.bam -o $output_dir/phased_whatshap_output.vcf --ignore-read-groups --indels --tag=PS --reference $output_dir/reference_uc.fasta --algorithm whatshap
  fi
elif [ "$phaser_uc" == "HAPCHAT" ]; then
  #phasing with HAPCHAT enable realignment only 1 step
  $WHATSHAP phase $unphased_vcf $output_dir/reads.filter.sorted.bam -o $output_dir/phased_hapchat_output.vcf --ignore-read-groups --indels --tag=PS --reference $output_dir/reference_uc.fasta --algorithm hapchat
elif [ "$phaser_uc" == "HAPCUT2" ]; then
  #phasing with HAPCUT2
  $EXTRACTHAIRS --ont 1 --bam $output_dir/reads.filter.sorted.bam --vcf $unphased_vcf --ref $reference --indels 1 --out $output_dir/fragment_file
  $HAPCUT2 --fragments $output_dir/fragment_file --VCF $unphased_vcf --outvcf 1 --error_analysis_mode 1 --output $output_dir/hapcut2_output
  mv $output_dir/hapcut2_output.phased.VCF $output_dir/phased_hapcut2_output.vcf
  #$PRUNE_HAPLOTYPE -i $output_dir/hapcut2_output -o $output_dir/hapcut2_pruned_output -mq 90 -sq 30 #(not used)
else
  echo "Phaser $phaser is not supported (choose between Whatshap, HAPCHAT and HapCUT2)"
  exit
fi

rm $output_dir/reads.filter.sorted.bam*
