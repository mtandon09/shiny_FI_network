rm(list=ls())

setwd("~/Documents/my_tools/shiny/gene_interaction_network/mirna_1/data")

mirna_data_url="http://mirtarbase.cuhk.edu.cn/cache/download/8.0/miRTarBase_MTI.xlsx"

mirna_data_file=basename(mirna_data_url)
if (!file.exists(mirna_data_file)) {
  download.file(url=mirna_data_url,destfile = mirna_data_file)
}

library(openxlsx)
mirna_data <- read.xlsx(mirna_data_file)
mirna_data <- mirna_data[mirna_data$`Species.(Target.Gene)`=="Homo sapiens",]

mirna_interactions <- data.frame(Gene1=mirna_data$miRNA, 
                                 Gene2=mirna_data$Target.Gene,
                                 change=-1)
mirna_interactions <- unique(mirna_interactions)
mirna_interactions$data_source <- "mirTarBase"

load("gene_interactions.Rdata")

if (! "data_source" %in% colnames(gene_int_mat.uniq)) {
  gene_int_mat.uniq$data_source="Reactome_FI"
}
gene_int_mat.uniq <- rbind(gene_int_mat.uniq, mirna_interactions)


save(gene_int_mat.uniq, file = "gene_interactions.with_mirna.Rdata")