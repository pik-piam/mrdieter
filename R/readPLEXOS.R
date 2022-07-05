#' Read PLEXOS World 2015 Electricity Demand
#' @md
#'
#' @return A [`magpie`][magclass::magclass] object.
#'
#' @author Falk Benke
#'
#' @importFrom dplyr select filter mutate
#' @importFrom rlang sym
#' @importFrom reshape2 melt
#' @importFrom magclass as.magpie
#'
#' @export
readPLEXOS <- function() {
  data <- read.csv2("All Demand UTC 2015.csv", sep = ",") %>%
    melt(id.vars = 1, variable.name = "region") %>%
    mutate(!!sym("region") := sub(".*?\\.", "", !!sym("region"))) %>%
    filter(!grepl("\\.", !!sym("region"))) %>%
    mutate(
      !!sym("period") := format(strptime(Datetime, "%d/%m/%Y"), "%Y"),
      !!sym("month") := format(strptime(Datetime, "%d/%m/%Y"), "%m"),
      !!sym("day") := format(strptime(Datetime, "%d/%m/%Y"), "%d"),
      !!sym("hour") := format(strptime(Datetime, "%d/%m/%Y %H:%M", "%M"), "%H"),
    ) %>%
    mutate(
      !!sym("hour") := ifelse(is.na(!!sym("hour")), "00", !!sym("hour")),
      !!sym("subannual") := paste0(!!sym("month"), "-", !!sym("day"), " ", !!sym("hour"), ":00"),
      !!sym("variable") := "FE|Electricity",
      !!sym("unit") := "MWh"
    ) %>%
    select(region, period, subannual, variable, unit, value)

  x <- as.magpie(data, temporal = c(2,3))
}



