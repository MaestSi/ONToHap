#!/bin/bash

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

usage="$(basename "$0") [-f fastq_reads] [-u unphased_vcf] [-p ground_truth_phased_vcf] [-r reference_fasta] [-o output_dir]"

while :
do
    case "$1" in
      -h | --help)
          echo $usage
          exit 0
          ;;
      -f)
          fastq_reads=$(realpath $2)
          shift 2
          echo "Fastq reads: $fastq_reads"
          ;;
      -u)
           unphased_vcf=$(realpath $2)
           shift 2
           echo "Unphased VCF: $unphased_vcf"
           ;;
      -p)
           ground_truth_phased_vcf=$(realpath $2)
           shift 2
           echo "Ground-truth phased VCF: $ground_truth_phased_vcf"
           ;;
      -r)
           reference_fasta=$(realpath $2)
           shift 2
           echo "Reference fasta: $reference_fasta"
           ;;
      -o)
           output_dir=$2
           shift 2
           echo "Output directory: $output_dir"
           ;;
       --) # End of all options
           shift
           break
           ;;
       -*)
           echo "Error: Unknown option: $1" >&2
           ## or call function display_help
           exit 1
           ;;
        *) # No more options
           break
           ;;
    esac
done

if [ ! -d $output_dir ]; then
  mkdir $output_dir
fi

output_dir_full=$(realpath $output_dir)
source activate ONToHap_env
PIPELINE_DIR=$(realpath $( dirname "${BASH_SOURCE[0]}" ))
nohup Rscript $PIPELINE_DIR/ONToHap_accuracy_test.R $fastq_reads $unphased_vcf $ground_truth_phased_vcf $reference_fasta $output_dir_full &
