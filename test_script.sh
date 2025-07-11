rm -r ./dbs/Dataset-Muaz/*
rm -r ./inputs/pcode/pcode_iscg/Dataset-Muaz_testing
rm -r ./inputs/pcode/pcode_sog/Dataset-Muaz_testing
rm -r ./inputs/pcode/pcode_tscg/Dataset-Muaz_testing
rm ./pairs_results_Dataset-Muaz_hms.csv

mkdir -p ./dbs/Dataset-Muaz/cfg_summary/testing
mkdir -p ./dbs/Dataset-Muaz/features/testing/pcode_raw_Dataset-Muaz_testing

cp ../../DBs/Dataset-Muaz/testing_Dataset-Muaz.csv ./dbs/Dataset-Muaz/
cp "../../DBs/Dataset-Muaz/pairs/pairs_testing_Dataset-Muaz.csv" ./dbs/Dataset-Muaz/
cp -r "../../DBs/Dataset-Muaz/features/acfg_disasm" ./dbs/Dataset-Muaz/features/testing/

# relatively fast
python3 lifting/dataset_summary.py --cfg_summary dbs/Dataset-Muaz/cfg_summary/testing --dataset_info_csv dbs/Dataset-Muaz/testing_Dataset-Muaz.csv --cfgs_folder ./dbs/Dataset-Muaz/features/testing/acfg_disasm/

# very slow
python3 lifting/pcode_lifter.py --cfg_summary ./dbs/Dataset-Muaz/cfg_summary/testing/ --output_dir ./dbs/Dataset-Muaz/features/testing/pcode_raw_Dataset-Muaz_testing --graph_type ALL --verbose 1 --nproc 30

# quite fast
./preprocess/preprocess_all.sh

# Output in ./inputs/pcode/pcode_iscg/Dataset-Muaz_testing/graph_func_dict_opc_True.pkl
# Output in ./inputs/pcode/pcode_sog/Dataset-Muaz_testing/graph_func_dict_opc_True.pkl
# Output in ./inputs/pcode/pcode_tscg/Dataset-Muaz_testing/graph_func_dict_opc_True.pkl

# Run the inference
python3 ./model/main.py --debug --config ./model/configures/e05.json --dataset=muaz --outputdir=./outputs/experiments/hermes_sim/0/ --device=cpu
# Output in ./outputs/experiments/hermes_sim/0/last/testing_Dataset-Muaz.pkl

# Convert results
python3 convert_hermessim_results.py
cp ./pairs_results_Dataset-Muaz_hms.csv ../../Results/csv/
