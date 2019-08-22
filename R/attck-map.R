#' Generate an ATT&CK heatmap
#'
#' @param xdf a data frame with `tactic`, `technique` and `value` columns.
#'        If no `value` column exists, then the function will assume you
#'        have passed in individual events and will perform a "count"
#'        summarization before generating the heatmap.
#' @param input,output,matrix if both are not `NULL` then they should be
#'        what [fct_tactic()] takes as parameters. Otherwise, the function
#'        will assume that the `tactic` column is already an ordered factor.
#' @param tile_col,tile_size color/size for the tile borders;
#'        defaults to "`white`" and `0.5`, respectively.
#' @param dark_lab,light_lab text colors for when they appear on top of a
#'        dark or light tile
#' @param dark_value_threshold since you can supply your own fill scale
#'        and may use a transformation (e.g. "`log10`") when doing so, you
#'        can specify the cutoff value for when to use `dark_lab` vs `light_lab`.
#'        If `NULL` then half of `max(value)` will be used.
#' @param ... passed on to the internal call to [ggplot2::geom_text()]
#' @return a ggplot2 plot object which you can add a fill scale to as well
#'         as themeing.
#' @export
attck_map <- function(xdf, input = NULL, output = NULL, matrix = NULL,
                      tile_col = "white", tile_size = 0.5,
                      dark_lab = "white", light_lab = "black",
                      dark_value_threshold = NULL, ...) {

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

  if (is.null(dark_value_threshold)) dark_value_threshold <- max(xdf$value)/2

  xdf <- dplyr::arrange(xdf, value)
  xdf$technique <- factor(gsub(" ", "\n", xdf$technique))
  xdf <- dplyr::group_by(xdf, tactic)
  xdf <- dplyr::mutate(xdf, ids = (n():1))
  xdf <- dplyr::ungroup(xdf)

  gg <- ggplot(xdf, aes(tactic, ids))
  gg <- gg + geom_tile(aes(fill = value), color = tile_col, size = tile_size)
  gg <- gg + geom_text(
    aes(
      label = technique,
      color = I(ifelse(value <= dark_value_threshold, dark_lab, light_lab))
    ), ...
  )
  gg <- gg + scale_x_discrete(expand = c(0, 0), position = "top")
  gg <- gg + scale_y_reverse(expand = c(0, 0))

  gg

}
