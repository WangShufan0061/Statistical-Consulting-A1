split_genre <- function(movies_clean){
  n = nrow(movies_clean)
  for (i in 1:n){
    genre_split <- unlist(strsplit(movies_clean$genres[i],","))
    n_class = length(genre_split)
    new_rows <-
      tibble(
        genres = genre_split,
        average_rating = rep(movies_clean$average_rating[i],n_class),
        num_votes = rep(movies_clean$num_votes[i],n_class)
    )
    movies_clean <- rbind(movies_clean, new_rows)
  }
  movies_clean <- movies_clean[-(1:1903),]
  return(movies_clean)
}
# pacman::p_load(tidyverse,targets)
# tar_load(movies_clean)
# temp<-split_genre(movies_clean)
# head(temp)
# temp |> group_by(genres)|>count()
