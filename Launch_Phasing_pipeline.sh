HOME_DIR=$1
HOME_DIR_FULL=$(realpath $HOME_DIR)
source activate ONToHap_env
PIPELINE_DIR=$(realpath $( dirname "${BASH_SOURCE[0]}" ))
nohup Rscript $PIPELINE_DIR/phasing_pipeline.R $HOME_DIR_FULL &

