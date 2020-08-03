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


READS=$1
REFERENCE=$2

MINIMAP2=/path/to/minimap2
SAMTOOLS=/path/to/samtools
MEDAKA=/path/to/medaka
MEDAKA_MODEL_SNPS="r941_min_high_g360"
MEDAKA_MODEL_VARIANTS="r941_min_high_g360"
THREADS=24

SAMPLE_NAME=$(echo $(basename $READS) | sed 's/\.fast.//g')
BAM=$(realpath $(dirname $READS))"/"$SAMPLE_NAME".bam"
OUTPUT_DIR=$(realpath $(dirname $READS))"/"$SAMPLE_NAME"_medaka_variant"

$MINIMAP2 -ax map-ont --MD -t $THREADS  $REFERENCE $READS | $SAMTOOLS view -h | $SAMTOOLS sort -o $BAM -T reads.tmp
$SAMTOOLS index $BAM
$MEDAKA"_variant" -i $BAM -f $REFERENCE -s $MEDAKA_MODEL_SNPS -m $MEDAKA_MODEL_VARIANTS -p $SAMPLE_NAME"_phased.vcf" -t $THREADS -o $OUTPUT_DIR
cat $OUTPUT_DIR"/round_1_phased.vcf" | grep -P "^#|PASS" > $SAMPLE_NAME"_phased_PASS.vcf"

