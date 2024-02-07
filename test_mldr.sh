language=$1

export index_path=indexes/mldr-$language
export input_path=collections/MLDR/$language/
export query_path=queries/MLDR/$language/
export split=test
export topic_path=$query_path/${split}_queries.tsv
export qrel_path=$query_path/${split}_qrels.tsv

mkdir -p runs/MLDR/
mkdir -p results/MLDR/

java -cp anserini-0.24.1-fatjar.jar io.anserini.search.SearchCollection \
  -index $index_path-analyzer \
  -topics $topic_path \
  -topicReader TsvString \
  -output runs/MLDR/$split-$language-analyzer.txt -format trec \
  -parallelism 64 \
  -bm25 -hits 1000 -language $language

java -cp anserini-0.24.1-fatjar.jar io.anserini.search.SearchCollection \
  -index $index_path-no-analyzer \
  -topics $topic_path \
  -topicReader TsvString \
  -output runs/MLDR/$split-$language-no-analyzer.txt -format trec \
  -parallelism 64 \
  -bm25 -hits 1000

ir_measures queries/MLDR/$language/${split}_qrels.tsv runs/MLDR/$split-$language-no-analyzer.txt nDCG@10 > results/MLDR/$split-$language-no-analyzer.txt
ir_measures queries/MLDR/$language/${split}_qrels.tsv runs/MLDR/$split-$language-analyzer.txt nDCG@10 > results/MLDR/$split-$language-analyzer.txt
echo "Result without correct analyzer"
cat results/MLDR/$split-$language-no-analyzer.txt
echo "Result with correct analyzer"
cat results/MLDR/$split-$language-analyzer.txt

