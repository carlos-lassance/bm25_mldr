language=$1

export index_path=indexes/MLDR/fused/
export input_path=collections/MLDR/$language/
export query_path=queries/MLDR/$language/
export split=test
export topic_path=$query_path/${split}_queries.tsv
export qrel_path=$query_path/${split}_qrels.tsv

mkdir -p runs/MLDR/
mkdir -p results/MLDR/

java -cp anserini-0.24.1-fatjar.jar io.anserini.search.SearchCollection \
  -index $index_path \
  -topics $topic_path \
  -topicReader TsvString \
  -output runs/MLDR/FUSED-$split-$language-no-analyzer.txt -format trec \
  -parallelism 64 \
  -bm25 -hits 1000

ir_measures queries/MLDR/$language/${split}_qrels.tsv runs/MLDR/FUSED-$split-$language-no-analyzer.txt nDCG@10 > results/MLDR/FUSED-$split-$language-no-analyzer.txt
echo "Result without analyzer (because impossible)"
cat results/MLDR/FUSED-$split-$language-no-analyzer.txt

