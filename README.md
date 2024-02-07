#BM25 for MLDR

This is a quick repo for testing BM25 for MLDR. It was prompted by the results published in [M3](https://arxiv.org/pdf/2402.03216.pdf) where the English results for BM25 are good, but not other languages.

The idea of this repo is to download the [collection from huggingface](https://huggingface.co/datasets/Shitao/MLDR) convert to an [Anserini](http://anserini.io/) friendly format and run evaluation.

The way this repo works is that each language has a separate index, as is the case for MIRACL. For one index with all languages (fused) I've also experimented in the end and results still are very different from the paper.

## Results

|      |   BM25 from paper |   M3-All from paper |   BM25-Anserini with analyzer |   BM25-Anserini without analyzer |
|:-----|------------------:|--------------------:|------------------------------:|---------------------------------:|
| ar   |              16   |                64.7 |                          57   |                             67   |
| de   |              36.9 |                57.9 |                          60.3 |                             58.5 |
| en   |              67.9 |                63.8 |                          67.9 |                             67.9 |
| es   |              42.6 |                86.8 |                          82.1 |                             81.9 |
| fr   |              51.6 |                83.9 |                          77.4 |                             76.2 |
| hi   |              16.2 |                52.2 |                          57.8 |                             58.5 |
| it   |              40.4 |                75.5 |                          74.7 |                             75   |
| ja   |               8.3 |                60.1 |                          58.2 |                             42.3 |
| ko   |              19.6 |                55.7 |                          51.6 |                             51   |
| pt   |              36.2 |                85.4 |                          80.7 |                             81.4 |
| ru   |              13.2 |                73.8 |                          73.6 |                             70.7 |
| th   |              26.2 |                44.7 |                          34.3 |                             29.8 |
| zh   |               0.5 |                40   |                          58   |                             28.2 |
| mean |              28.9 |                65   |                          64.1 |                             60.6 |

## Reproducing the experiments

* First convert the data with the ConvertAnserini notebook. That should take a few minutes to download everything
* Download the anserini fatjar `wget https://repo1.maven.org/maven2/io/anserini/anserini/0.24.1/anserini-0.24.1-fatjar.jar`
* Run indexing and retrieval with run_all.sh. That should take a half an hour to run.
* Condensate results and print with MergeEval.

Which shows greatly improveed results with BM25. I'm not sure if I did something different from them, but the English results being exactly the same seem to point out the problem is more on the use of other languages and the BM25 they used. 

I would like to note that the "Which BM25 problem" is a common thing to happen, and that going outside of English evaluation increases such problems. For a showcase on the "Which BM25 problem":

Kamphuis, C., de Vries, A.P., Boytsov, L., Lin, J. (2020). Which BM25 Do You Mean? A Large-Scale Reproducibility Study of Scoring Variants. In: Jose, J., et al. Advances in Information Retrieval. ECIR 2020. Lecture Notes in Computer Science(), vol 12036. Springer, Cham. https://doi.org/10.1007/978-3-030-45442-5_4

On the case of non-english bm25, multiple problems can happen. For example it is common that in zh there could be a mismatch between documents and queries where some use Traditional and other Simple variants of the written language, making it hard to do lexical match. 

## Installation

There's a requirements file for the python part and you need to download the anserini fatjar for running the java commands.

## EXTRA: Experiment with fused index

I was afraid that maybe my numbers were so different because I had evaluated the corpus separately for each language. However even on the full corpus of all languages, results are still much better than on the paper.

|      |   BM25 from paper |   M3-All from paper |   BM25-Anserini with analyzer |   BM25-Anserini without analyzer |   BM25 with fused corpus |
|:-----|------------------:|--------------------:|------------------------------:|---------------------------------:|-------------------------:|
| ar   |              16   |                64.7 |                          57   |                             67   |                     61.4 |
| de   |              36.9 |                57.9 |                          60.3 |                             58.5 |                     50.9 |
| en   |              67.9 |                63.8 |                          67.9 |                             67.9 |                     65.8 |
| es   |              42.6 |                86.8 |                          82.1 |                             81.9 |                     80.5 |
| fr   |              51.6 |                83.9 |                          77.4 |                             76.2 |                     70   |
| hi   |              16.2 |                52.2 |                          57.8 |                             58.5 |                     50.6 |
| it   |              40.4 |                75.5 |                          74.7 |                             75   |                     65.5 |
| ja   |               8.3 |                60.1 |                          58.2 |                             42.3 |                     42.9 |
| ko   |              19.6 |                55.7 |                          51.6 |                             51   |                     41   |
| pt   |              36.2 |                85.4 |                          80.7 |                             81.4 |                     74.5 |
| ru   |              13.2 |                73.8 |                          73.6 |                             70.7 |                     64.7 |
| th   |              26.2 |                44.7 |                          34.3 |                             29.8 |                     25.1 |
| zh   |               0.5 |                40   |                          58   |                             28.2 |                     28.3 |
| mean |              28.9 |                65   |                          64.1 |                             60.6 |                     55.5 |
