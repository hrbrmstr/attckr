#' Validate Technique IDs
#'
#' @param technique_ids a character vector of technique ids to validate
#' @param matrix which matrix to validate against (not all IDs are associated
#'        with techniques in every matrix)
#' @param na_rm remove NA's before comparing?
#' @export
validate_technique_ids <- function(technique_ids,
                                   matrix = c("enterprise", "mobile", "pre"),
                                   na_rm = TRUE) {

  matrix <- match.arg(matrix[1], c("enterprise", "mobile", "pre"))

  switch(
    matrix,
    enterprise = "mitre-attack",
    mobile = "mitre-mobile-attack",
    pre = "mitre-pre-attack"
  ) -> tax

  if (na_rm) {
    no_na <- na.exclude(technique_ids)
    where_nas <- attr(no_na, "na.action", exact = TRUE)
    if (length(where_nas)) message("Removed ", length(where_nas), " NA values.\n")
    tec <- as.character(no_na)
  }

  mtec <- unique(tidy_attack[tidy_attack$matrix == tax, "id", drop=TRUE])

  bad <- unique(tec[which(!(tec %in% mtec))])

  if (length(bad)) {
    warning(
      "Technique ids not in the ", matrix, " MITRE ATT&CK matrix found\n",
      paste0(sprintf('- "%s"', sort(unique(bad))), collapse = "\n"),
      call. = FALSE
    )
    invisible(sort(unique(bad)))
  } else {
    message(
      "All techniques were found in the ", matrix, " MITRE ATT&CK matrix"
    )
    invisible(TRUE)
  }


}