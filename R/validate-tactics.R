#' Validate Tactics strings against MITRE authoritative source
#'
#' @param tactics a character vector of tactic strings to validate. This will be
#'        converted to lower-case, left/right spaces will be trimmed and
#'        internal spaces will be converted to a single `-`
#' @param matrix which matrix to use when validating?
#' @param na_rm remove NA's before comparing?
#' @return `TRUE` if all tactics validate, otherwise `FALSE` with messages
#'         identifying the invalid tactics.
#' @export
#' @examples
#' validate_tactics("persistence")
#' validate_tactics(c("persistence", "Persistence", "Persistance"))
validate_tactics <- function(tactics, matrix = c("enterprise", "mobile", "pre"),
                             na_rm = TRUE) {

  matrix <- match.arg(matrix[1], c("enterprise", "mobile", "pre"))

  switch(
    matrix,
    enterprise = "mitre-attack",
    mobile = "mitre-mobile-attack",
    pre = "mitre-pre-attack"
  ) -> tax

  tax <- unique(tidy_attack[tidy_attack$matrix == tax, "tactic", drop=TRUE])

  if (na_rm) {
    no_na <- na.exclude(tactics)
    where_nas <- attr(no_na, "na.action", exact = TRUE)
    if (length(where_nas)) message("Removed ", length(where_nas), " NA values.\n")
    tac <- as.character(no_na)
  }

  o_tac <- tactics

  tac <- normalize_identifier(tactics)

  bad <- o_tac[which(!(tac %in% tax))]

  if (length(bad)) {
    warning(
      "Tactics not in the ", matrix, " MITRE ATT&CK matrix found\n",
      paste0(sprintf('- "%s"', sort(unique(bad))), collapse = "\n"),
      call. = FALSE
    )
    invisible(sort(unique(bad)))
  } else {
    message(
      "All tactics were found in the ", matrix, " MITRE ATT&CK matrix"
    )
    invisible(TRUE)
  }

}

