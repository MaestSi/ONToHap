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
