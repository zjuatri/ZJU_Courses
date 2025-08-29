
#Experimental Setting
INPUT_DIR=../data/test/clean/fake/ 
OUTPUT_DIR=../data/test/advData/fake/
MODEL_NUM=1
MAX_EPS=10
NUM_ITER=10
GPU_ID=0

python attack2.py  --input_dir=${INPUT_DIR} --output_dir=${OUTPUT_DIR} \
                        --max_epsilon=${MAX_EPS} \
                        --model_num=${MODEL_NUM} --num_iter=${NUM_ITER} \
                        --gpu_id=${GPU_ID} 

python eval.py  --imgs_dir=${OUTPUT_DIR} \
                --max_epsilon=${MAX_EPS} \
                --model_num=${MODEL_NUM} --num_iter=${NUM_ITER} \
                --gpu_id=${GPU_ID}


