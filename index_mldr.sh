language=$1

export index_path=indexes/mldr-$language
export input_path=collections/MLDR/$language/
export query_path=queries/MLDR/$language/
export split=test
export topic_path=$query_path/${split}_queries.tsv
export qrel_path=$query_path/${split}_qrels.tsv

rm -rf $index_path
rm -rf $index_path-analyzer
rm -rf $index_path-no-analyzer
mkdir -p runs/MLDR/
mkdir -p indexes

java -cp anserini-0.24.1-fatjar.jar io.anserini.index.IndexCollection \
   -collection JsonCollection \
   -input $input_path \
   -index $index_path-analyzer \
   -generator DefaultLuceneDocumentGenerator \
   -threads 9 -language $language

java -cp anserini-0.24.1-fatjar.jar io.anserini.index.IndexCollection \
   -collection JsonCollection \
   -input $input_path \
   -index $index_path-no-analyzer \
   -generator DefaultLuceneDocumentGenerator \
   -threads 9