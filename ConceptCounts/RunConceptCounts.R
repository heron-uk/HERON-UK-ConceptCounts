start_time <- Sys.time()

outputFolder <- here::here("Results")

log_file <- file.path(outputFolder, paste0("/log_", omopgenerics::cdmName(cdm), "_", format(Sys.time(), "%d_%m_%Y_%H_%M_%S"),".txt"))

omopgenerics::createLogFile(logFile = log_file)

result <- list()

omopgenerics::logMessage("Getting snapshot")

result[["snapshot"]] <- OmopSketch::summariseOmopSnapshot(cdm = cdm)

tableName <- intersect(c("visit_occurrence","visit_detail", "condition_occurrence", "drug_exposure", "procedure_occurrence",
               "device_exposure", "measurement" , "observation", "death"), names(cdm))

omopgenerics::logMessage(paste0("Starting concept counts in ", paste(tableName, collapse = ", ")))

result[["conceptCounts"]] <- OmopSketch::summariseConceptIdCounts(cdm = cdm,
                                               omopTableName = tableName,
                                               countBy = c("record", "person"),
                                               interval = "years",
                                               sex = FALSE,
                                               ageGroup = NULL,
                                               dateRange = as.Date(c("2012-01-01", NA)),
                                               sample = NULL)

# Calculate duration and log
dur <- abs(as.numeric(Sys.time() - start_time, units = "secs"))

omopgenerics::logMessage(paste("Study code finished. Code ran in", floor(dur / 60), "min and", dur %% 60 %/% 1, "sec"))

# Zip the results
omopgenerics::logMessage("Export and zip results")

omopgenerics::exportSummarisedResult(result |> omopgenerics::bind(),
                                     minCellCount = minCellCount,
                                     fileName = "result_concept_counts_{cdm_name}.csv",
                                     path = outputFolder)


