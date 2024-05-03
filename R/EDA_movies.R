EDA_movies <- function(movies_file){
  movies_df <-read_xlsx(movies_file)
  movies_summary <- skimr::skim(movies_df)
  movies_missing <- naniar::vis_miss(movies_df)
  genres_unique <- movies_df|>group_by(genres)|> count()|> gt()|>fmt_number(col=2)
  averate_histgram <-
    movies_df |>
    ggplot(aes(average_rating))+
    geom_histogram(col='black',fill='orange')
  numvote_histgram <-
    movies_df |>
    ggplot(aes(num_votes))+
    geom_histogram(col='black',fill='orange')
  scatter_plot<-
    movies_df|>
    ggplot(aes(log(num_votes),log(average_rating)))+
    geom_point()
  result <- list('movies_summary'=movies_summary,
                 'missing_plot' = movies_missing,
                 'genres_count'=genres_unique,
                 'ave_rate_hist'= averate_histgram,
                 'num_votes_hist'=numvote_histgram,
                 'scatter_plot'=scatter_plot)
  return(result)
}
  # pacman::p_load(tidyverse, targets,gt,readxl)
  # tar_load(movies_file)
  # EDA_movies(movies_file)
