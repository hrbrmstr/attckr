% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/validate-tech-ids.R
\name{validate_technique_ids}
\alias{validate_technique_ids}
\title{Validate Technique IDs}
\usage{
validate_technique_ids(
  technique_ids,
  matrix = c("enterprise", "mobile", "pre"),
  na_rm = TRUE
)
}
\arguments{
\item{technique_ids}{a character vector of technique ids to validate}

\item{matrix}{which matrix to validate against (not all IDs are associated
with techniques in every matrix)}

\item{na_rm}{remove NA's before comparing?}
}
\description{
Validate Technique IDs
}
