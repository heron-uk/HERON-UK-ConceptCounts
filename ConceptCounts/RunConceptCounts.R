start_time <- Sys.time()

outputFolder <- here::here("Results")

log_file <- file.path(outputFolder, paste0("/log_", cdmName, "_", format(Sys.time(), "%d_%m_%Y_%H_%M_%S"),".txt"))

omopgenerics::createLogFile(logFile = log_file)

result <- list()

omopgenerics::logMessage("Getting snapshot")

result[["snapshot"]] <- OmopSketch::summariseOmopSnapshot(cdm = cdm)

tableName <- intersect(c("visit_occurrence","visit_detail", "condition_occurrence", "drug_exposure", "procedure_occurrence",
               "device_exposure", "measurement" , "observation", "death"), names(cdm))

omopgenerics::logMessage(paste0("Starting concept counts in ", paste(tableName, collapse = ", ")))

sex <- FALSE
ageGroup <- list(c(0, 17), c(18, 65), c(66, Inf) )
interval <- "years"
dateRange <- as.Date(c("2012-01-01", NA))

result[["conceptCounts"]] <- OmopSketch::summariseConceptIdCounts(cdm = cdm,
                                               omopTableName = tableName,
                                               countBy = c("record", "person"),
                                               interval = interval,
                                               sex = sex,
                                               ageGroup = ageGroup,
                                               dateRange = dateRange,
                                               sample = NULL)

# Calculate duration and log
dur <- abs(as.numeric(Sys.time() - start_time, units = "secs"))

omopgenerics::logMessage(paste("Study code finished. Code ran in", floor(dur / 60), "min and", dur %% 60 %/% 1, "sec"))

# Close connection
CDMConnector::cdmDisconnect(cdm)

omopgenerics::logMessage("Database connection closed")

# Zip the results
omopgenerics::logMessage("Export and zip results")

omopgenerics::exportSummarisedResult(result |> omopgenerics::bind(),
                                     minCellCount = minCellCount,
                                     fileName = "result_concept_counts_{cdm_name}.csv",
                                     path = outputFolder)



files_to_zip <- list.files(outputFolder)
files_to_zip <- files_to_zip[stringr::str_detect(files_to_zip, cdmName)]

zip::zip(
  zipfile = file.path(paste0(outputFolder, "/results_concept_counts_", cdmName, ".zip")),
  files = files_to_zip,
  root = outputFolder
)

