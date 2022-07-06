#' Read PLEXOS World 2015 Electricity Demand
#' @md
#'
#' @return A [`magpie`][magclass::magclass] object.
#'
#' @author Falk Benke
#'
#' @importFrom dplyr select filter mutate
#' @importFrom magclass as.magpie dimReduce
#' @importFrom rlang sym
#' @importFrom reshape2 melt
#' @importFrom utils read.csv2
#'
#' @export
readPLEXOS <- function() {

  .getHourOfYear <- function(time){

    dayOfYear <- as.integer(format(strptime(time, "%d/%m/%Y"), '%j')) - 1
    hourOfDay <- as.integer(format(strptime(time, "%d/%m/%Y %H:%M"), '%H'))
    hourOfDay[is.na(hourOfDay)] <- 0

    return(as.character(dayOfYear * 24 + hourOfDay + 1))
  }

  data <- read.csv2("All Demand UTC 2015.csv", sep = ",") %>%
    melt(id.vars = 1, variable.name = "region") %>%
    mutate(region = sub(".*?\\.", "", !!sym("region"))) %>%
    filter(!grepl("\\.", !!sym("region"))) %>%
    mutate(hour = .getHourOfYear(!!sym("Datetime")), year = "2015") %>%
    filter(!!sym("region") != "KOS") %>%
    select("region", "year", "hour", "value")


  as.magpie(data) %>% dimReduce() %>% return()
}
