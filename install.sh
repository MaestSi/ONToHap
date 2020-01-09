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

git clone https://github.com/vibansal/HapCUT2.git
cd HapCUT2
make
cd ..

conda config --add channels bioconda
conda config --add channels conda-forge
conda config --add channels r
conda create -n ONToHap_env python=3.6 seqtk minimap2 bwa whatshap samtools r

PIPELINE_DIR=$(realpath $( dirname "${BASH_SOURCE[0]}" ))
MINICONDA_DIR=$(which conda | sed 's/miniconda3.*$/miniconda3\/envs\/ONToHap_env\/bin/')

ln -s $PIPELINE_DIR/HapCUT2/build/extractHAIRS $MINICONDA_DIR
ln -s $PIPELINE_DIR/HapCUT2/build/HAPCUT2 $MINICONDA_DIR

echo "MINICONDA_DIR=$MINICONDA_DIR" | cat - tools.sh > temp && mv temp tools.sh
chmod 755 tools.sh

echo "PIPELINE_DIR=$PIPELINE_DIR"
echo "SEQTK="$MINICONDA_DIR"/seqtk"
