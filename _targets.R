
library(targets)
library(tarchetypes)

tar_option_set(
  packages = c("tidyverse","readxl","gt","randomForest", "caret","tidymodels","vip","paletteer"),
  format ="rds"
)



tar_source()


list(
  tar_file(movies_file, "raw-data/2024-3-1-movies-raw.xlsx"),
  tar_target(movies_EDA,EDA_movies(movies_file)),
  tar_target(movies_clean, clean_movies(movies_file)),
  tar_target(movies_split, split_genre(movies_clean)),
  tar_target(movies_boxplot, plot_boxplot(movies_split)),
  tar_target(numvote_mean, mean_numvote(movies_split)),
  tar_target(movies_rf, rf_movies(movies_split)),
  tar_quarto(readme,"README.qmd")
)
