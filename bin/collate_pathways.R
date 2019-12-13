#!/usr/bin/env Rscript

#load/install packages as required
pkg <- c('dplyr', 'ggplot2', 'purrr', 'readr')
new.pkg <- pkg[!(pkg %in% installed.packages())]
if (length(new.pkg)) {
  install.packages(new.pkg)
}
library(dplyr)
library(ggplot2)
library(purrr)
library(readr)

#define function to collate all results
collate_results <- function(folder) {
  #load and clean filenames
  input_files <- list.files(paste0('../interproscan/',folder), pattern='*.txt', full.names = TRUE)
  filenames <- basename(input_files)
  filenames <- gsub('_bp.txt|_cc.txt|_mf.txt|_kegg.txt|_metacyc.txt|_reactome.txt|_genomic', '', filenames)
  #load files
  dflist <- lapply(input_files, read_tsv, col_names=c('pathway'))
  names(dflist) <- filenames
  # obtain counts of each pathway in each file
  count_list <- dflist
  for(df_name in names(dflist)) {
    count_list[[df_name]] <- as.data.frame(table(dflist[[df_name]]))
    colnames(count_list[[df_name]]) <- c('pathway', df_name)
  }
  collated <- reduce(count_list, full_join, by='pathway') %>% 
    replace(., is.na(.), 0)
}

# collate all results
bp <- collate_results('go_bp')
cc <- collate_results('go_cc')
mf <- collate_results('go_mf')
kegg <- collate_results('kegg')
metacyc <- collate_results('metacyc')
reactome <- collate_results('reactome')


# write all results as a table
write.table(bp, file='../interproscan/bp.tsv', col.names = TRUE, row.names = FALSE, sep='\t')
write.table(cc, file='../interproscan/cc.tsv', col.names = TRUE, row.names = FALSE, sep='\t')
write.table(mf, file='../interproscan/mf.tsv', col.names = TRUE, row.names = FALSE, sep='\t')
write.table(kegg, file='../interproscan/kegg.tsv', col.names = TRUE, row.names = FALSE, sep='\t')
write.table(metacyc, file='../interproscan/metacyc.tsv', col.names = TRUE, row.names = FALSE, sep='\t')
write.table(reactome, file='../interproscan/reactome.tsv', col.names = TRUE, row.names = FALSE, sep='\t')

print('Script Complete...')





