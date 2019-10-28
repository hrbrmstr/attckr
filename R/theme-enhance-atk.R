#' Remove cruft from ATT&CK heatmaps
#'
#' @export
theme_enhance_atkmap <- function () {
  ret <- theme(panel.grid = element_blank())
  ret <- ret + theme(axis.text.y = element_blank())
  ret <- ret + theme(axis.title = element_blank())
  ret <- ret + theme(axis.title.x = element_blank())
  ret <- ret + theme(axis.title.x.top = element_blank())
  ret <- ret + theme(axis.title.x.bottom = element_blank())
  ret <- ret + theme(axis.title.y = element_blank())
  ret <- ret + theme(axis.title.y.left = element_blank())
  ret <- ret + theme(axis.title.y.right = element_blank())
  ret <- ret + theme(legend.position = "bottom")
  ret <- ret + theme(legend.key.width = unit(3, "lines"))
  ret
}