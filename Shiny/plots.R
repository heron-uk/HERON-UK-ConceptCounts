
library(duckdb)
library(CodelistGenerator)
library(CDMConnector)
library(here)
library(dplyr)
library(stringr)

load(here("data", "shinyData.RData"))

con <- dbConnect(drv = duckdb(dbdir = here("data", "my_vocab.duckdb")))
cdm <- cdmFromCon(con = con, cdmSchema = "main", writeSchema = "main")

cdms <- c("Barts Health", "GOSH DRE", "DataLoch", "AurumCDM_202409", "IDRIL_1", "LTHT", "UCLH-from-2019")
level <- "ATC 3rd"

atcCodes <- getATCCodes(cdm = cdm, level = level, nameStyle = "{concept_code}") |>
  as_tibble() |>
  rename(concept_code = "codelist_name") |>
  inner_join(
    cdm$concept |>
      filter(vocabulary_id == "ATC") |>
      select("concept_code", "concept_name") |>
      collect(),
    by = "concept_code"
  ) |>
  inner_join(
    data$summarise_concept_id_counts |>
      filter(age_group == "overall", sex == "overall") |>
      mutate(concept_id = as.integer(variable_level)) |>
      select("concept_id", "count_records", "cdm_name"),
    by = "concept_id",
    relationship = "many-to-many"
  ) |>
  group_by(concept_code, concept_name, cdm_name) |>
  summarise(counts = sum(count_records), .groups = "drop")

atc1 <- cdm$concept |>
  filter(concept_class_id == "ATC 1st") |>
  select(atc1 = "concept_name", ancestor_concept_id = "concept_id") |>
  inner_join(
    cdm$concept_ancestor |>
      select("ancestor_concept_id", "descendant_concept_id") |>
      inner_join(
        cdm$concept |>
          filter(vocabulary_id == "ATC") |>
          select("concept_code", descendant_concept_id = "concept_id"),
        by = "descendant_concept_id"
      ),
    by = "ancestor_concept_id"
  ) |>
  select("atc1", "concept_code") |>
  collect()

atcCodes <- atcCodes |>
  left_join(atc1, by = "concept_code")

x <- atcCodes |>
  mutate(atc1 = str_to_sentence(atc1), concept_name = str_to_sentence(concept_name)) |>
  group_by(atc1, concept_code, concept_name) |>
  summarise(counts = sum(counts), .groups = "drop") |>
  mutate(id = row_number(), counts = log(counts), counts = counts / max(counts) + 0.1)

x <- x |>
  mutate(
    angle = 90 - 360 * (id / n()),  # position labels around circle
    hjust = ifelse(angle < -90, 1, 0),  # flip labels on left side
    angle = ifelse(angle < -90, angle + 180, angle)  # correct text orientation
  )

ggplot(x, aes(x = as.factor(id), y = counts, fill = atc1)) +
  geom_bar(stat = "identity", alpha = 0.7) +
  ylim(-2.5, 5) +
  coord_polar(start = 0) +
  geom_text(
    aes(
      y = counts + 0.05,           # move text slightly outside bar
      label = concept_name,
      angle = angle,
      hjust = hjust
    ),
    size = 1.2
  ) +
  labs(fill = "") +
  theme_minimal() +
  theme(
    axis.text = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    legend.position = "right"
  )
