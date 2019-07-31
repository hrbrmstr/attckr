#' Make an ordered Tactics factor with optional better labelling
#'
#' Uses the metadat in [tactics_f] to make it easier to build ordered factors.
#'
#' You may receive Tatics encoded in one of many forms, including:
#'
#' - `taid` (Tactic ID) the official MITRE ATT&CK tactic id (e.g. "`TA0001`")
#' - `id` (Tactic text id) lowercase-dashed name (e.g. "`initial-access`")
#' - `pretty` (Tactic text) Upper/lowercase name suitable for display (e.g. "`Initial Access`")
#' - `nl` (Tactic text) same as ^ but w/newlines for space constrained display (e.g. "`Initial\\nAccess`")
#'
#' @param tactics a character vector
#' @param input what is in `tactics`? (See Details)
#' @param output what do you want the factor label to be? (See Details)
#' @param matrix which matrix? ("`enterprise`", "`mobile`", "`pre`")
#' @seealso [tactics_f] for direct access to the ordered Tactics
#' @export
#' @examples
#' fct_tactic(c("initial-access", "persistence"), "id", "nl")
fct_tactic <- function(tactics,
                       input = c("id", "pretty", "nl", "taid"),
                       output = c("pretty", "nl", "id", "taid"),
                       matrix = c("enterprise", "mobile", "pre")) {

  input <- match.arg(input[1], c("id", "pretty", "nl", "taid"))
  output <- match.arg(output[1], c("id", "pretty", "nl", "taid"))
  matrix <- match.arg(matrix[1], c("enterprise", "mobile", "pre"))

  switch(
    matrix,
    enterprise = "mitre-attack",
    mobile = "mitre-mobile-attack",
    pre = "mitre-pre-attack"
  ) -> tax

  input <- tactics_f[[tax]][[input]]
  output <- tactics_f[[tax]][[output]]

  factor(x = tactics, levels = input, labels = output, ordered = TRUE)

}
