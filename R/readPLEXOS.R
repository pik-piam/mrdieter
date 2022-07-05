#' Read PLEXOS World 2015 Electricity Demand
#' @md
#'
#' @return A [`magpie`][magclass::magclass] object.
#'
#' @author Falk Benke
#'
#' @importFrom dplyr select filter mutate
#' @importFrom magclass as.magpie
#' @importFrom rlang sym
#' @importFrom reshape2 melt
#' @importFrom utils read.csv2
#'
#' @export
readPLEXOS <- function() {
  data <- read.csv2("All Demand UTC 2015.csv", sep = ",") %>%
    melt(id.vars = 1, variable.name = "region") %>%
    mutate(region = sub(".*?\\.", "", !!sym("region"))) %>%
    filter(!grepl("\\.", !!sym("region"))) %>%
    mutate(
      period = format(strptime(!!sym("Datetime"), "%d/%m/%Y"), "%Y"),
      month = format(strptime(!!sym("Datetime"), "%d/%m/%Y"), "%m"),
      day = format(strptime(!!sym("Datetime"), "%d/%m/%Y"), "%d"),
      hour = format(strptime(!!sym("Datetime"), "%d/%m/%Y %H:%M", "%M"), "%H"),
    ) %>%
    mutate(
      hour = ifelse(is.na(!!sym("hour")), "00", !!sym("hour")),
      subannual = paste0(!!sym("month"), "-", !!sym("day"), " ", !!sym("hour"), ":00"),
      variable = "FE|Electricity",
      unit = "MWh"
    ) %>%
    select("region", "period", "subannual", "variable", "unit", "value")

  as.magpie(data, temporal = c(2, 3)) %>% return()
}
