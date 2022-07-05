#' Calculate electricity demand
#'
#' @md
#' @return A [`magpie`][magclass::magclass] object.
#'
#' @author Falk Benke
#'
#' @export
calcElectricityDemand <- function() {
  x <- readSource("PLEXOS")

  return(list(
    x = x,
    weight = NULL,
    unit = "MWh",
    description = "Hourly Electricity Demand for PLEXOS-World 2015"
  ))
}
