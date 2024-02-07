for language in ar de en es fr hi it ja ko pt ru th zh
do
    bash index_mldr.sh $language
    bash test_mldr.sh $language
done
bash index_fused.sh
for language in ar de en es fr hi it ja ko pt ru th zh
do
    bash test_fused.sh $language
done
