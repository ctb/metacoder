




## An R package for planning amplicon metagenomics research and plotting taxonomy-associated information

Zachary S. L. Foster and Niklaus J. Grünwald

### Introduction 

Metabarcoding is revolutionizing microbial ecology and presenting new challenges:

* Taxonomic data is stored in numerous database formats making it difficult to parse, combine, and subset.
* Commonly used stacked bar charts are ineffective for taxonomic data with multiple ranks or treatments.
* There is much under-explored bias associated with the choice of barcode loci and primers.

MetacodeR is an R package that attempts to addresses these issues:

* Taxonomic data from almost any format can be parsed easily and missing data can be retrieved from online databases.
* Taxonomic data can be mapped to size and color and graphed on a tree, as in a heat map.
* *In silico* PCR is used to evaluate primer specificity and functions are being developed to use barcode gap analysis to estimate error rates of barcode loci.

### Extracting taxonomic data

Most databases have unique file formats and taxonomic hierarchies/nomenclature.
Taxonomic data can be extracted from almost any file format using the **extract_taxonomy** function.
Taxon names/IDs and sequence IDs can be used to get taxonomic data from online databases or embedded data can be parsed offline.
A regular expression with capture groups and a corresponding key is used to define how to parse the file.
The example code below parses the 16s RPD training set for Mothur:


```r
library(metacoder)
seqs <- ape::read.FASTA("trainset10_082014.rdp.fasta")
cat(names(seqs)[1]) # print an example of the sequence headers
```

```
## AB294171_S001198039	Root;Bacteria;Firmicutes;Bacilli;Lactobacillales;Carnobacteriaceae;Alkalibacterium
```

```r
data <- extract_taxonomy(seqs, regex = "^(.*)\\t(.*)", key = c(seq_id = "item_info", "class_name"),
                         class_tax_sep = ";", database = "none")
head(taxon_data(data))
```

```
##   taxon_id parent_id item_count rank              name
## 1        1      <NA>      10650    1              Root
## 2        2         1      10240    2          Bacteria
## 3        3         2       1956    3        Firmicutes
## 4        4         3       1214    4           Bacilli
## 5        5         4        411    5   Lactobacillales
## 6        6         5         39    6 Carnobacteriaceae
```

The object that results contains sequence information associated with a taxonomic hierarchy.

### Plotting

The hierarchical nature of taxonomic data makes it difficult to plot effectively.
Most often, bar charts, stacked bar charts, or pie graphs are used, but these are ineffective when plotting many taxa and multiple ranks.
The function plot_taxonomy makes a tree utilizing color and size to display taxonomic data (e.g. sequence abundance):


```r
plot(data, vertex_size = item_count, 
     vertex_label = name, vertex_color = item_count)
```

![](README_files/figure-html/unnamed-chunk-4-1.svg)

Any statistic can be mapped to tree element color and size.
The size range displayed is optimized for each graph.
There are many options to customize the appearance of the graph, but all have useful defaults.
Plotting is flexible enough for pipelines and controlled enough for publications. 




```r
plot(data, vertex_size = item_count, vertex_label = name, layout = "davidson-harel",
     vertex_color = item_count, vertex_color_range = c("cyan", "magenta", "green"),
     edge_color = rank, edge_color_range   = c("#555555", "#EEEEEE"), overlap_avoidance = 0.5)
```

![](README_files/figure-html/unnamed-chunk-6-1.svg)

### Subsetting

Taxonomic data can be easily subsetted by any information associated with it using the **subset** function.
There are options to preserve or discard the children (i.e. subtaxa) and parents (i.e. supertaxa) of selected taxa.
**subset** can be used to look at just the data for Archaea:




```r
plot(subset(data, name == "Archaea"), vertex_size = item_count, 
     vertex_label = name, vertex_color = item_count, layout = "fruchterman-reingold")
```

![](README_files/figure-html/unnamed-chunk-8-1.svg)

To make the archaea-bacteria division more clear, the root taxa can be removed, causing two trees to be plotted:




```r
subsetted <- subset(data, rank > 1)
plot(subsetted, vertex_size = item_count, vertex_label = name,
     vertex_color = item_count, layout = "davidson-harel", tree_label = name)
```

![](README_files/figure-html/unnamed-chunk-10-1.svg)


### Subsampling

When calculating statistics for taxa from reference databases the amount of data should be distributed evenly among taxa and there should be enough data per taxon to make reliable estimates.
Random samples of large reference databases are biased toward culturable taxa with plentiful data.
The function **taxonomic_sample** is used to create taxonomically balanced random subsamples.
Taxa with too few sequences or sub-taxa are excluded and taxa with too many are sampled.
The code below subsamples the data such that rank 6 taxa will have 5 sequences and rank 3 taxa (phyla) will have less than 100. 




```r
sampled <- taxonomic_sample(subsetted, max_counts = c("3" = 100, "6" = 5), min_counts = c("6" = 5))
sampled <- subset(sampled, item_count > 0, itemless = FALSE) 
```




```r
plot(sampled, vertex_size = item_count, vertex_label = item_count, tree_label = name,
     vertex_color = item_count, layout = "davidson-harel", vertex_label_max = 100)
```

![](README_files/figure-html/unnamed-chunk-14-1.svg)


### In silico PCR

The function **primersearch** is a wrapper for the an EMBOSS tool that implements *in silico* PCR.
The code below estimates the coverage of the universal bacterial primer pair 357F/519F: 


```r
pcr <- primersearch(sampled, forward = "CTCCTACGGGAGGCAGCAG", reverse = "GWATTACCGCGGCKGCTG",
                    pair_name = "357F_519R",  mismatch = 10)
head(taxon_data(pcr))
```

```
##   taxon_id parent_id item_count rank count_amplified prop_amplified
## 2        2      <NA>       1881    1            1658      0.8814460
## 3        3         2        230    2             221      0.9608696
## 4        4         3        100    3              97      0.9700000
## 5        5         4         38    4              37      0.9736842
## 6        6         5          3    5               3      1.0000000
## 7        7         6          1    6               1      1.0000000
##                name
## 2          Bacteria
## 3        Firmicutes
## 4           Bacilli
## 5   Lactobacillales
## 6 Carnobacteriaceae
## 7   Alkalibacterium
```

The proportion of sequences amplified can be mapped to color in a plot:




```r
plot(pcr, vertex_size = item_count, vertex_label = name, vertex_color = prop_amplified,
     vertex_color_range =  c("red", "#d95f02", "#1b9e77", "#7570b3"),
     vertex_color_trans = "radius", tree_label = name)
```

![](README_files/figure-html/unnamed-chunk-17-1.svg)

This plot makes it apparent that no Archaea were amplified and most Bacteria were amplified, but not all.
We can subset the data to better see what Bacteria did not get amplified:


```r
library(magrittr) # Adds optional %>% operator for chaining commands
pcr %>%
  subset(name == "Bacteria") %>%
  subset(count_amplified < item_count, subtaxa = FALSE) %>% 
  plot(vertex_size = item_count, vertex_label = name, vertex_color = prop_amplified,
       vertex_color_range =  c("red", "#d95f02", "#1b9e77", "#7570b3"),
       vertex_color_interval = c(0, 1), vertex_color_trans = "radius")
```

![](README_files/figure-html/unnamed-chunk-18-1.svg)

We can compare the effectiveness of primer pair 357F/519F to 515F/1100R.
First we do *in silco* PCR with 515F/1100R and combine the results:


```r
pcr_2 <- primersearch(sampled, forward = "GTGCCAGCMGCCGCGGTAA", reverse = "AGGGTTGCGCTCGTTG",
                      pair_name = "515F_1100R", mismatch = 10)
pcr$taxon_data$count_amplified_2 <- taxon_data(pcr_2, "count_amplified")
pcr$taxon_data$prop_diff <- taxon_data(pcr, "prop_amplified") - taxon_data(pcr_2, "prop_amplified")
```

Then taxa that are not amplified by both pairs can be subsetted and the difference in amplification plotted:


```r
pcr %>%
  subset(name == "Bacteria") %>%
  subset(count_amplified < item_count | count_amplified_2 < item_count, subtaxa = FALSE) %>%
  plot(vertex_size = item_count, vertex_label = name,
       vertex_color = prop_diff, vertex_color_range = diverging_palette(),
       vertex_color_interval = c(-1, 1), vertex_color_trans = "radius")
```

![](README_files/figure-html/unnamed-chunk-20-1.svg)

In the above graph, blue means taxa were amplified by 357F/519F but not 515F/1100R; brown means the opposite.


### Conclusions and acknowledgements

The ability to estimate the effectiveness of new primers/barcodes will accelerate the adoption of metabarcoding to understudied groups of organisms and intuitive plotting will reveal subtle patterns in complex data.
This package is currently being developed and can be installed from GitHub using the following code:


```r
devtools::install_github("grunwaldlab/metacoder")
```

We thank Tom Sharpton for sharing his metagenomics expertise and advising us.
This R package is built upon others, notably taxize, igraph, and ggplot2.


### Download the current version

While this project is in development it can be installed through github:

    devtools::install_github(repo="grunwaldlab/metacoder", build_vignettes=TRUE)
    library(metacoder)

If you've built the vignettes, you can browse them with:

    browseVignettes(package="metacoder")


### Documentation

Documentation is under construction at http://grunwaldlab.github.io/metacoder.
