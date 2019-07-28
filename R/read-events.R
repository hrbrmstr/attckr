#' Read in ATT&CK events from a file
#'
#' This is a convenience wrapper for [readr::read_csv()] that sets up
#' a contract to read in incident events with some pre-determined expectations.
#' See Details for more information.
#'
#' While sufficient metadata and helpers have been provided with this package
#' to enable customized use of the ATT&CK matricies sometimes you just want
#' to get stuff done quickly and for that we need to establish some ground rules.
#'
#' This function defines and "incident event" record as something that
#' contains the fields:
#'
#' - `event_id`: a unique identifier for this event
#' - `incident_id`: the associated incident for the `event_id`; again, a unique
#'   identifier for each incident
#' - `event_ts`: the timestamp for when the event occurred (anything date-like)
#' - `detection_ts`: the timestamp for when the event was detected (anything date-like)
#' - `tactic`: the ATT&CK Tactic; can be in "id" format (dashed lowercase), "pretty"
#'   (spaces, titlecase), or "newline" (newlines, titlecase)
#' - `technique`: the ATT&CK Technique id or precise spelling if spelled out
#' - `discovery_source`: free text field (it should still be "identifier-ish")
#'   that helps pinpoint which control/logging source enabled discovery of the
#'   event.
#' - `reporting_source`: free text field (it should still be "identifier-ish")
#'   that identifies what did the reporting for the `discovery_source`.
#' - `responder_id` the id of the incident reponder associated with this
#'   combination of `event_id` and `incident_id`.
#'
#' You can think of `discovery_source` & `reporting_source` this way: say
#' the Windows Event Log captured the evidence of a failed (or successful)
#' local admin logon event. It passes that on to your centralized logging
#' facility and/or your SIEM. You can make `discovery_source` "`Windows Event Log`"
#' and `reporting_source` whichever technology you used.
#'
#' Any column not-present will be turned into `NA`. Columns not matching the
#' above names will be removed from the object returned.
#' @param path path to a CSV file that contains ATT&CK events. This will be [path.expand()]ed.
#' @param matrix which matrix are the events associated with?
#' @param ... passed on to [readr::read_csv()]
#' @export
#' @examples
#' read_events(system.file("extdat/sample-incidents.csv.gz", package = "attckr"))
read_events <- function(path, matrix = c("enterprise", "mobile", "pre"), ...) {

  matrix <- match.arg(matrix[1], c("enterprise", "mobile", "pre"))

  switch(
    matrix,
    enterprise = "mitre-attack",
    mobile = "mitre-mobile-attack",
    pre = "mitre-pre-attack"
  ) -> tax

  path <- path.expand(path[1])

  stopifnot(file.exists(path))

  xdf <- suppressWarnings(readr::read_csv(path, ...))

  c(
    "event_id", "incident_id", "event_ts", "detection_ts", "tactic",
    "technique", "discovery_source", "reporting_source", "responder_id"
  ) -> req_fields

  col_miss <- setdiff(req_fields, colnames(xdf))
  if (length(col_miss)) for (fld in col_miss) xdf[[fld]] <- NA_character_

  xdf <- xdf[,req_fields]

  if (any(grepl("\n", xdf[["tactic"]]))) {
    fct_tactic(
      tactics = xdf[["tactic"]],
      input = "nl",
      output = "pretty",
      matrix = matrix
    ) -> xdf[["tactic"]]
    message("You appear to be using Tactic full names with crlfs.")
  } else if (any(grepl("[[:upper:]]", xdf[["tactic"]]))) {
    fct_tactic(
      tactics = xdf[["tactic"]],
      input = "pretty",
      output = "pretty",
      matrix = matrix
    ) -> xdf[["tactic"]]
    message("You appear to be using Tactic full names.")
  } else if (any(grepl("-", xdf[["tactic"]]))) {
    fct_tactic(
      tactics = xdf[["tactic"]],
      input = "id",
      output = "pretty",
      matrix = matrix
    ) -> xdf[["tactic"]]
    message("You appear to be using Tactic ids.")
  } else {
    warning("Could not identify Tactic encoding.",  call. = FALSE)
  }

  if (all(grepl("^[[:upper:]]+[\\-]*[[:digit:]]+$", xdf[["technique"]]))) {
    message("You appear to be using Techinque ids.")
  } else if (any(tidy_attack$technique %in% xdf[["technique"]])) {
    message("You appear to be using Technique full names.")
  } else {
    warning("Could not determine if you are using Technique ids or names.", call. = FALSE)
  }

  xdf

}
