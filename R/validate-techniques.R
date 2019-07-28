#' Validate Techniques strings against MITRE authoritative source
#'
#' @param tactics a character vector of tactic strings to validate.
#' @param matrix which matrix to use when validating?
#' @param ignore_case if `TRUE` case will not be taken into account when
#'        comparing strings. Default is `FALSE`.
#' @param na_rm remove NA's before comparing?
#' @return `TRUE` if all tactics validate, otherwise `FALSE` with messages
#'         identifying the invalid tactics.
#' @export
#' @examples
#' validate_techniques("persistence")
#' validate_techniques(c("persistence", "Persistence", "Persistance"))
validate_techniques <- function(techniques, matrix = c("enterprise", "mobile", "pre"),
                                ignore_case = FALSE, na_rm = TRUE) {

  matrix <- match.arg(matrix[1], c("enterprise", "mobile", "pre"))

  switch(
    matrix,
    enterprise = "mitre-attack",
    mobile = "mitre-mobile-attack",
    pre = "mitre-pre-attack"
  ) -> tax

  if (na_rm) {
    no_na <- na.exclude(techniques)
    where_nas <- attr(no_na, "na.action", exact = TRUE)
    if (length(where_nas)) message("Removed ", length(where_nas), " NA values.\n")
    tec <- as.character(no_na)
  }

  mtec <- unique(tidy_attack[tidy_attack$matrix == tax, "technique", drop=TRUE])
  o_tec <- tec

  if (ignore_case) {
    o_tec <- tolower(tec)
    mtec <- tolower(mtec)
  }

  bad <- unique(o_tec[which(!(tec %in% mtec))])

  if (length(bad)) {

    bad <- sort(bad)
    suggest <- sapply(bad, agrep, x = mtec, ignore.case = ignore_case)
    suggest <- ifelse(lengths(suggest) == 0, "No suggestions found", suggest)

    do.call(
      rbind.data.frame,
      lapply(names(suggest), function(x) {
        data.frame(
          input = x,
          alts = as.character(suggest[[x]]),
          stringsAsFactors = FALSE
        ) %>% as_tibble()
      })
    ) -> suggest

    can_suggest <- which(suggest[["alts"]] != "No suggestions found")

    suggest[can_suggest, "alts"] <- sprintf('Perhaps: "%s"',
                                            mtec[as.integer(suggest[can_suggest, "alts", drop=TRUE])])

    warning(
      "Techniques not in the ", matrix, " MITRE ATT&CK matrix found:\n",
      paste0(sprintf('- "%s (%s)"', suggest$input, suggest$alts), collapse = "\n"),
      call. = FALSE
    )

    invisible(
      tibble(
        input = suggest$input,
        alts = suggest$alts
      )
    )

  } else {
    message("All techniques were found in the ", matrix, " MITRE ATT&CK Framework.")
    invisible(TRUE)
  }

}