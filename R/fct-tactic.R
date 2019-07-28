#' Make an ordered Tactics factor with optional better labelling
#'
#' @param tactics a character vector
#' @param input what is in `tactics`?
#' @param output what do you want the factor label to be?
#' @param matrix which matrix?
#' @seealso [tactics_f] for direct access to the ordered Tactics
#' @export
fct_tactic <- function(tactics,
                       input = c("id", "pretty", "nl"),
                       output = c("pretty", "nl", "id"),
                       matrix = c("enterprise", "mobile", "pre")) {

  input <- match.arg(input[1], c("id", "pretty", "nl"))
  output <- match.arg(output[1], c("id", "pretty", "nl"))
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
