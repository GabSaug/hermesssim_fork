import pickle
import tqdm
import csv
import argparse
import torch
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity

def load_function_metadata(functions_csv_path):
    df = pd.read_csv(functions_csv_path)
    df["key"] = df["idb_path"].astype(str) + "_" + df["func_name"].astype(str).str.lower()
    return df.set_index("key")

def load_embeddings(embedding_path):
    with open(embedding_path, 'rb') as f:
        emb_data = pickle.load(f)
    return emb_data

def compute_similarity(embedding1, embedding2):
    sim = cosine_similarity(embedding1.reshape(1, -1), embedding2.reshape(1, -1))
    return float(sim[0][0])

def main(args):
    # Load metadata and embeddings
    print("[*] Loading function metadata and embeddings...")
    function_df = load_function_metadata(args.functions_csv)
    embeddings = load_embeddings(args.embeddings)

    # Load the pairs
    print("[*] Loading function pairs...")
    pairs_df = pd.read_csv(args.pairs_csv)

    results = []

    print("[*] Computing similarities...")
    for _, row in tqdm.tqdm(pairs_df.iterrows(), total=len(pairs_df)):
        key1 = f"{row['idb_path_1']}_{str(row['func_name_1']).lower()}"
        key2 = f"{row['idb_path_2']}_{str(row['func_name_2']).lower()}"

        try:
            idx1 = function_df.index.get_loc(key1)
            idx2 = function_df.index.get_loc(key2)
        except KeyError:
            print(f"[!] Could not find one or both keys: {key1}, {key2}")
            continue

        emb1 = embeddings[idx1]
        emb2 = embeddings[idx2]

        sim = compute_similarity(emb1, emb2)
        results.append({
            "idb_path_1": row['idb_path_1'],
            "func_name_1": row['func_name_1'],
            "idb_path_2": row['idb_path_2'],
            "func_name_2": row['func_name_2'],
            "sim": sim
        })

    results_df = pd.DataFrame(results)
    if args.output:
        results_df.to_csv(args.output, index=False)
        print(f"[*] Results saved to {args.output}")
    else:
        print(results_df)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--pairs_csv", default="../../DBs/Dataset-Muaz/pairs/pairs_testing_Dataset-Muaz.csv", help="CSV file with function pairs")
    parser.add_argument("--functions_csv", default="./dbs/Dataset-1/testing_Dataset-1.csv", help="CSV file with all function metadata")
    parser.add_argument("--embeddings", default="./outputs/Dataset-Muaz/testing_Dataset-1.pkl", help="Path to .pt file containing embeddings")
    parser.add_argument("--output", default="./pairs_results_Dataset-Muaz_hms.csv", help="Path to save output CSV with similarity scores")
    args = parser.parse_args()
    main(args)
