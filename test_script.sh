#  First, constuct CFG summary files:
## Compatibility: dataset_info_csv: ../../DBs/Dataset-1/testing_Dataset-1.csv ?
## Compatibility: cfgs_folder: ../../DBs/Dataset-1/features/acfg_disasm/ ?
#
rm ./pairs_results_Dataset-Muaz_hms.csv
rm dbs/Dataset-1/cfg_summary/testing/*

mkdir -p ./dbs/Dataset-1/cfg_summary/testing/
mkdir -p ./dbs/Dataset-1/features/testing/
cp ../../DBs/Dataset-Muaz/testing_Dataset-Muaz.csv ./dbs/Dataset-1/testing_Dataset-1.csv
cp "../../DBs/Dataset-Muaz/pairs/pairs_testing_Dataset-Muaz.csv" ./dbs/Dataset-1/

echo 1
python3 lifting/dataset_summary.py \
    --cfg_summary ./dbs/Dataset-1/cfg_summary/testing \
    --dataset_info_csv ../../DBs/Dataset-Muaz/testing_Dataset-Muaz.csv \
    --cfgs_folder ../../DBs/Dataset-Muaz/features/acfg_disasm

# Then, lifting binaries
echo 2
python3 lifting/pcode_lifter.py \
    --cfg_summary ./dbs/Dataset-1/cfg_summary/testing \
    --output_dir ./dbs/Dataset-1/features/testing/pcode_raw_Dataset-1_testing \
    --graph_type ALL \
    --verbose 1 \
    --nproc 29

# Preprocess input

mkdir -p inputs/pcode

echo 3
echo "Processing Dataset-1_testing"
python preprocess/preprocessing_pcode.py \
    --freq-mode -f pkl -s Dataset-1_testing \
    -i dbs/Dataset-1/features/testing/pcode_raw_Dataset-1_testing \
    -o inputs/pcode

# Model Training / Inferring

echo 4
python3 model/main.py --debug --dataset=one --config ./my_config2.json --test_outdir ./outputs/ -o ./outputs/ --device cpu

		# copy the output Dataset-1 to dataset-Muaz file

python3 convert_hermessim_results.py
cp ./pairs_results_Dataset-Muaz_hms.csv ../../Results/csv/
echo -e "\n*** Pairs results saved in ../../Results/csv"
