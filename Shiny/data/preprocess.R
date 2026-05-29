# shiny is prepared to work with this resultList:
resultList <- list(
  summarise_omop_snapshot = list(result_type = "summarise_omop_snapshot"),
  summarise_concept_id_counts = list(result_type = "summarise_concept_id_counts")
)

source(file.path(getwd(), "functions.R"))

result <- omopgenerics::importSummarisedResult(file.path(getwd(), "results"))
data <- prepareResult(result, resultList)
values <- getValues(result, resultList)

# edit choices and values of interest
choices <- values
selected <- getSelected(values)

data$summarise_concept_overall_counts <- omopgenerics::tidy(data$summarise_concept_id_counts) |>
  dplyr::filter(time_interval == "overall") |>
  dplyr::select(!"time_interval") |>
  rename(concept_id = variable_level, concept_name = variable_name) |>
  mutate(concept_id  = as.integer(concept_id))

save(data, choices, selected, values, file = file.path(getwd(), "data", "shinyData.RData"))

rm(result, values, choices, selected, resultList, data)
