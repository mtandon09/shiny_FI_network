# shiny_FI_network
Shiny app for plotting gene functional interaction networks



# Install Required Packages
In the following code, `list.of.packages` is a character vector of all the required packages.
The code will only install packages that are not available in the current R environment.
```
list.of.packages <- c("shiny","shinyjs","shinyBS","openxlsx","igraph","qgraph","ggnetwork","network","intergraph","RColorBrewer","ggnewscale")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
```

# Run from GitHub in RStudio
```
library(shiny)
runGitHub( "shiny_FI_network", "mtandon09")
```
