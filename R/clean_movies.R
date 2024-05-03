
clean_movies <-function(movies_file){
  movies_df <-read_xlsx(movies_file)
  movies_df <- movies_df|>
    filter( christmas !=FALSE)|>
    select(genres,average_rating,num_votes)|>
    na.omit()
  return(movies_df)
}
#pacman::p_load(tidyverse,targets)
#library(readxl)
#tar_load(movies_file)
#clean_movies(movies_file)
