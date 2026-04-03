# formatting the gff: extracting genes, adding 1000 bp flanks on either side and also saving original coordinates (without flanks)

awk -F'\t' '$3 == "gene"' *.gff | awk '{OFS="\t"}NR>1{print $1,$4-1000,$5+1000,$1":"$4"-"$5}' | awk '{OFS="\t"}{if ($2 > 0)  print $1":"$2"-"$3,$4; else print $1":"1"-"$3,$4;}' > genes_coord.txt

# splitting the genes in 999 files, so that later we can parallelize the sweeps analysis by running each file containing a list of approx. 20-50 genes (total number of genes/999 files) as a separate job (999 HPC jobs in total)

mkdir genes_files
split --numeric-suffixes=1 -n l/999 -d genes_coord.txt splitted
mv splitted* genes_files
find . -name "splitted*" > genes_files_list.txt
