plot_boxplot <- function(movies_split){
  movies_split$genres<-fct_lump_prop(movies_split$genres,0.01)
  movies_split|>
    ggplot(aes(genres,average_rating,fill=genres))+
    geom_boxplot()+
    theme(legend.position="none",axis.text.x = element_text(angle = 60, hjust = 1, vjust = 1))
}
# pacman::p_load(tidyverse,targets)
# tar_load(movies_split)
# plot_boxplot(movies_split)
