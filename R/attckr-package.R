#' Analyze Adversary Tactics and Techniques Using the MITRE ATT&CK CTI Corpus
#'
#' MITRE ATT&CK&trade; is a globally-accessible knowledge base of
#' adversary tactics and techniques based on real-world observations.
#' The ATT&CK knowledge base is used as a foundation for the development
#' of specific threat models and methodologies in the private sector,
#' in government, and in the cybersecurity product and service community.
#' Tools are provided to analyze adversary tactics and techniques,
#' build incident metrics, and identify high level program gaps
#' using the MITRE ATT&CK CTI Corpus.
#'
#' @md
#' @name attckr
#' @docType package
#' @author Bob Rudis (bob@@rud.is)
#' @import tibble ggplot2 shiny rmarkdown stringi
#' @importFrom glue glue
#' @importFrom dplyr filter distinct mutate select case_when group_by arrange count n
#' @importFrom readr read_csv
#' @importFrom jsonlite fromJSON
#' @import ggplot2 grid gtable
"_PACKAGE"