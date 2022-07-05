#' Convert PLEXOS data
#'
#' @md
#' @param x A [`magpie`][magclass::magclass] object returned from
#'          [`readPLEXOS()`].
#'
#' @return A [`magpie`][magclass::magclass] object.
#'
#' @author Falk Benke
#'
#' @importFrom dplyr %>%
#' @importFrom madrat toolCountryFill
#'
#' @export
convertPLEXOS <- function(x) {
  x %>%
    toolCountryFill(fill = 0, verbosity = 2) %>%
    return()
}
