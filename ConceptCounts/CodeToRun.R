renv::activate()
renv::restore()

library(DBI)
library(CDMConnector)
library(OmopSketch)
library(odbc)
library(RPostgres)


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
