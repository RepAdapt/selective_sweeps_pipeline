# formatting the gff: extracting genes, adding 1000 bp flanks on either side and also saving original coordinates (without flanks)

awk -F'\t' '$3 == "gene"' *.gff | awk '{OFS="\t"}NR>1{print $1,$4-1000,$5+1000,$1":"$4"-"$5}' | awk '{OFS="\t"}{if ($2 > 0)  print $1":"$2"-"$3,$4; else print $1":"1"-"$3,$4;}' > genes_coord.txt
