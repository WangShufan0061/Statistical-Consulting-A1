
rf_movies <-function(movies_split){
set.seed(2024)
# bootstrap folds
movies_folds <- bootstraps(movies_split, strata =genres )
movies_folds

movies_recipe<-
  recipe(average_rating ~ genres+num_votes, data=movies_split)|>
  step_normalize(all_numeric_predictors())|>
  step_other(genres,threshold = 0.01)|>
  step_dummy(all_nominal_predictors(),one_hot = TRUE)|>
  step_interact(terms=~num_votes:starts_with("genre"))
movies_recipe|>prep()|>juice()


movies_rf_model <-
  rand_forest(
    mtry=tune(),
    min_n=tune(),
    trees = 100
  )|>
  set_mode("regression")|>
  set_engine("ranger",importance = "permutation")

movies_rf_wf<-
  workflow()|>
  add_recipe(movies_recipe)|>
  add_model(movies_rf_model)

movies_grid <- grid_regular(
  mtry(c(1,15)),
  min_n(),
  levels = 5
)

doParallel::registerDoParallel()
movies_tune <- tune_grid(
  object = movies_rf_wf,
  resamples = movies_folds,
  grid = movies_grid
)
movies_tune |> autoplot()

show_best(movies_tune, metric = "rmse", n = 10)
(M1 <- select_best(movies_tune, metric = 'rmse'))

movies_final_rf <-
  movies_rf_wf%>%
  finalize_workflow(M1)


movies_final_fits <-movies_final_rf|>fit(movies_split)

movies_split|>
  add_column(
    predict(movies_final_fits,new_data=movies_split)
  )

p<-movies_final_fits %>%
  fit(movies_split) %>%
  extract_fit_parsnip() %>% vi() |>
  #add_column(Sign =sign(Importance))|>
  #filter(Importance>1)|>
  ggplot(aes(Importance, fct_reorder(Variable, Importance),fill=as.factor(sign(Importance)))) +
  geom_col() +
  labs(y = NULL) +
  scale_fill_paletteer_d("dutchmasters::view_of_Delft")
#number of votes has significant impact on the average_rating.
#"Family","Drama" and "Comedy" are recomanded because they can attract numerous viewers
#即使他们的评分没有horror高，依然也可以通过吸引大量audience对aver_rating有积极作用。

result<-list('model'=movies_final_rf,'rmse'=show_best(movies_tune, metric = "rmse", n = 10)$mean[1],"VIP"=p)
return(result)
}
 #pacman::p_load(tidyverse,targets,randomForest, caret,tidymodels,vip)
# tar_load(movies_split)
# rf_movies(movies_split)
