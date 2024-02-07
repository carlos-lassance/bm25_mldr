export index_path=indexes/MLDR/fused
export input_path=collections/MLDR/fused

rm -rf $index_path
mkdir -p runs/MLDR/
mkdir -p indexes

mkdir -p collections/MLDR/fused
cat collections/MLDR/*/* > $input_path/fused_collection.jsonl
#cd $input_path
#split fused_collection.jsonl --additional-suffix=.jsonl
#rm fused_collection.jsonl
#cd ../../../

java -cp anserini-0.24.1-fatjar.jar io.anserini.index.IndexCollection \
   -collection JsonCollection \
   -input $input_path \
   -index $index_path \
   -generator DefaultLuceneDocumentGenerator \
   -threads 9