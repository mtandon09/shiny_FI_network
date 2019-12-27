# shiny_FI_network
## Shiny app for plotting gene functional interaction networks
Currently only accepts manually entered genes (expression/mutation data not implemented yet)

Use cases:
- Enter a few genes to view their interacting neighbors
-- e.g `BRCA2, MSH2`
- Enter a mature microRNA name to view their interacting neighbors (targets)
-- e.g. `hsa-miR-5100`
-- Select `mirTarBase` as the data source
- Enter a large list (say top 250 differentially expressed genes) and exclude neighbors to view interactions among them
-- You can include neighbors if you like, but the resulting plot is usually too busy to be informative



To do: enable file upload to overlay fold-change or mutation data

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



## Data Sources
### Reactome FI
From the Wu et. al [2010 paper](https://genomebiology.biomedcentral.com/articles/10.1186/gb-2010-11-5-r53), this dataset expands on the Reactome pathway database by adding annotation data.
>We have constructed a protein functional interaction network by extending curated pathways with non-curated sources of information, including protein-protein interactions, gene coexpression, protein domain interaction, Gene Ontology (GO) annotations and text-mined protein interactions, which cover close to 50% of the human proteome.

The data can be found in the [Downloads page at Reactome](https://reactome.org/download-data) under "Functional interactions (FIs) derived from Reactome, and other pathway and interaction databases".
### miRNA Targets
miRTarBase [[paper]](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5753222/)[[website]](http://mirtarbase.cuhk.edu.cn/php/index.php)
