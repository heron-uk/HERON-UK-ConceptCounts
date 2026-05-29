
con <- duckdb::dbConnect(drv = duckdb::duckdb(dbdir = "data/my_vocab.duckdb"))
cdm <- CDMConnector::cdmFromCon(con = con, cdmSchema = "main", writeSchema = "main", cdmName = "vocab")

vocab <- list(
  concept_relationship = cdm$concept_relationship |> 
    dplyr::select(concept_id_1, concept_id_2, relationship_id) |> 
    dplyr::collect(),
  concept = cdm$concept |> 
    dplyr::collect(),
  concept_ancestor = cdm$concept_ancestor |>
    dplyr::select(!"max_levels_of_separation") |>
    dplyr::collect()
)

# filter if needed
load(file = file.path(getwd(), "data", "shinyData.RData"))
concepts <- data$summarise_concept_id_counts$variable_level |>
  as.integer() |>
  unique()
vocab$concept_relationship <- vocab$concept_relationship |>
  dplyr::filter(concept_id_1 %in% concepts | concept_id_2 %in% concepts)
vocab$concept_ancestor <- vocab$concept_ancestor |>
  dplyr::filter(ancestor_concept_id %in% concepts | descendant_concept_id %in% concepts)
vocab$concept <- vocab$concept |>
  dplyr::filter(concept_id %in% concepts)

vocabVersion <- cdm$vocabulary |>
  dplyr::filter(.data$vocabulary_id == "None") |>
  dplyr::pull("vocabulary_version")
saveRDS(vocabVersion, file = "data/vocab_version.rds")
saveRDS(vocab, file = "data/vocabulary.rds")
