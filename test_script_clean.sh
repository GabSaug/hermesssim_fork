mkdir dbs/Dataset-Muaz/cfg_summary/testing
mkdir -p ./dbs/Dataset-Muaz/features/testing/pcode_raw_Dataset-Muaz_testing
# relatively fast
python3 lifting/dataset_summary.py --cfg_summary dbs/Dataset-Muaz/cfg_summary/testing --dataset_info_csv ../../DBs/Dataset-Muaz/testing_Dataset-Muaz.csv --cfgs_folder ../../DBs/Dataset-Muaz/features/acfg_disasm/

# very slow
python3 lifting/pcode_lifter.py --cfg_summary ./dbs/Dataset-Muaz/cfg_summary/testing/ --output_dir ./dbs/Dataset-Muaz/features/testing/pcode_raw_Dataset-Muaz_testing --graph_type ALL --verbose 1 --nproc 30

# quite fast
./preprocess/preprocess_all.sh

# Output in ./inputs/pcode/pcode_iscg/Dataset-Muaz_testing/graph_func_dict_opc_True.pkl
# Output in ./inputs/pcode/pcode_sog/Dataset-Muaz_testing/graph_func_dict_opc_True.pkl
# Output in ./inputs/pcode/pcode_tscg/Dataset-Muaz_testing/graph_func_dict_opc_True.pkl
