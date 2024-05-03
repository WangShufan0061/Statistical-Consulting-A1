mean_numvote <- function(movies_split){
  movies_split$genres<-
    fct_lump_prop(movies_split$genres,0.01)
 return( movies_split|>
    group_by(genres)|>
    summarise_at(vars(num_votes),mean)|>
      gt()|>
      cols_label(num_votes = "mean")|>
      fmt_number(col=2))
}
 # pacman::p_load(tidyverse,pacman,gt)
 # tar_load(movies_split)
 # mean_numvote(movies_split)
