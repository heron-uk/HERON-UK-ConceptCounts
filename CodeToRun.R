renv::activate()
renv::restore()
cdmName <- "..."

con <- DBI::dbConnect("...")

cdmSchema <- "..."
writeSchema <- "..."

prefix <- "..."


cdm <- CDMConnector::cdmFromCon(con = con,
                                cdmSchema = cdmSchema,
                                writeSchema = writeSchema,
                                writePrefix = prefix,
                                cdmName = cdmName)

minCellCount <- 5

source("RunConceptCounts.R")
