#' Product an ATT&CK Cumulative Distribution Function by Tactic
#'
#' @param xdf a data frame with `tactic`, `technique` and `value` columns.
#'        If no `value` column exists, then the function will assume you
#'        have passed in individual events and will perform a "count"
#'        summarization before generating the heatmap.
#' @param input,output,matrix if both are not `NULL` then they should be
#'        what [fct_tactic()] takes as parameters. Otherwise, the function
#'        will assume that the `tactic` column is already an ordered factor.
#' @param ... passed on to [ggplot2::geom_label()]
#' @export
attck_cdf_tactic <- function(xdf, input = NULL, output = NULL, matrix = NULL,  ...) {

  cn <- colnames(xdf)
  if (!all(c("tactic", "technique") %in% cn)) {
    stop("'xdf' needs both 'tactic' and 'technique' columns.", call.=FALSE)
  }

  if (!("value" %in% cn)) {
    xdf <- dplyr::count(xdf, tactic, technique, name = "value")
  }

  if (is.null(input) && is.null(output)) {
    if (!is.factor(xdf$tactic)) {
      stop(
        "No 'input'/'output' transformation specified but 'tactic' is not a factor.",
        call.=FALSE
      )
    }
  } else {
    if (sum(c(!is.null(input), !is.null(output), !is.null(matrix))) != 3) {
      stop("Must specify 'input', 'output', and 'matrix' if any one of them is not NULL", call.=FALSE)
    }
    xdf$tactic <- fct_tactic(xdf$tactic, input = input, output = output, matrix = matrix)
  }

  xdf <- dplyr::count(xdf, tactic, wt=value)
  xdf <- dplyr::arrange(xdf, tactic)
  xdf <- dplyr::mutate(xdf, pct = n/sum(n))
  xdf <- dplyr::mutate(xdf, cpct = cumsum(pct))

  gg <- ggplot(xdf, aes(tactic, cpct, group=1))
  gg <- gg + geom_path()
  gg <- gg + geom_label(
    aes(
      label = sprintf("%s\n%s\n%s", scales::comma(n), scales::percent(pct), scales::percent(cpct)),
    ), lineheight = 0.875, ...
  )
  gg <- gg + scale_x_discrete(
    expand = c(0, 0.5), position = "top",
    breaks = levels(xdf$tactic), limits = levels(xdf$tactic)
  )
  gg <- gg + scale_y_continuous(
    expand = c(0, 0.05), limits = c(-0.05, 1.05), label = scales::percent
  )
  gg <- gg + labs(x = NULL, y = NULL)

  gg

}
