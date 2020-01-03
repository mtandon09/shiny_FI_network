# Functional Networks of Gene Interactions (FuNGIn)
*like fun+engine*
 
## Shiny app for plotting gene functional interaction networks

You can view interactions between genes by entering a HUGO gene symbol

The idea is that you can EITHER 
 * view interactions among your *top N significant genes*
 * OR view interactions among genes of interest, and overlay expression data if available
 

Use cases:
- Enter a few genes to view their interacting neighbors
    * e.g `BRCA2, MSH2`
- Enter a mature microRNA name to view their interacting neighbors (targets)
    * e.g. `hsa-miR-5100`
    * Select at least `mirTarBase` as the data source
- Enter a large list (say top 250 differentially expressed genes) and exclude neighbors to view interactions among them
    * You can include neighbors if you like, but the resulting plot is usually too busy to be informative
- Use expression data with any combination of the above


## How to run
### Install Required Packages
```
list.of.packages <- c("shiny","shinyjs","shinyBS","openxlsx","igraph","qgraph","ggnetwork","network","intergraph","RColorBrewer","ggnewscale")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

list.of.bioc.packages <- c("maftools")
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
new.bioc.packages <- list.of.bioc.packages[!(list.of.bioc.packages %in% installed.packages()[,"Package"])]
if(length(new.bioc.packages)) BiocManager::install(new.bioc.packages)
```

### Run from GitHub in RStudio
```
library(shiny)
runGitHub( "shiny_FI_network", "mtandon09", ref="with_mirna")
```


## Differential Expression Data

You can also upload a tab/comma-delimited or .xlsx file with differential expression information.
The following data are recognized:
- HUGO Gene Symbol (required)
- Fold-change Value (log fold-change values make for better coloring)
- Significance Value (adjusted p-value, FDR, etc.)


## Data Sources
### Reactome FI
From the Wu et. al [2010 paper](https://genomebiology.biomedcentral.com/articles/10.1186/gb-2010-11-5-r53), this dataset expands on the Reactome pathway database by adding annotation data.
>We have constructed a protein functional interaction network by extending curated pathways with non-curated sources of information, including protein-protein interactions, gene coexpression, protein domain interaction, Gene Ontology (GO) annotations and text-mined protein interactions, which cover close to 50% of the human proteome.

The data can be found in the [Downloads page at Reactome](https://reactome.org/download-data) under "Functional interactions (FIs) derived from Reactome, and other pathway and interaction databases".
### miRNA Targets
miRTarBase [[paper]](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5753222/)[[website]](http://mirtarbase.cuhk.edu.cn/php/index.php)


# To Do
- Enable file upload to overlay mutation data
- Lots of control flow changes
- Lots of aesthetic changes for the network plot
- Lots of UI changes
