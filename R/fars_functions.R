#' Read source data file
#'
#' @details This function looks for a CSV file called \code{filename} and checks whether it exists or not,
#' if found it loads the data using \code{readr::read.csv} and converts it to a dyplr dataframe using \code{dyplr::tbl_df}.
#' If no data file with that name exists, the funtion returns an error.
#'
#' @param filename a string and, optionally a path, representing a CSV file name
#'
#' @import dplyr
#' @importFrom readr read_csv
#'
#' @return a dplyr dataframe
#'
#' @examples
#' \dontrun{
#' fars_read("accident_2013.csv")}
#'
#' @export
fars_read <- function(filename) {
        if(!file.exists(filename))
                stop("file '", filename, "' does not exist")
        data <- suppressMessages({
                readr::read_csv(filename, progress = FALSE)
        })
        dplyr::tbl_df(data)
}

#' Standard data file name
#'
#' @details This function returns a standard name  for a given year for the source zip files
#' from the US National Highway Traffic Safety Administration's Fatality Analysis Reporting System
#'
#' @param year an integer year value (YYYY)
#'
#' @return a string representing a standard file name for a given year
#'
#' @examples
#' \dontrun{
#' make_filename("accident_%d.csv.bz2", 2013)
#' Creates a standard file name for the 2017 dataset
#' }
#'
#' @export
make_filename <- function(year) {
        year <- as.integer(year)
        sprintf("inst/ext_data/accident_%d.csv.bz2", year)
}

#' Data date range
#'
#' This function returns the month and year of the data in a range of annual data files
#'
#'  @details This function iterates over a range of year values and uses the \code{\link{fars_read}} and \code{\link{make_filename}}
#'  to find and report the content of the MONTH and YEAR columns in each data file. The data files have to be in the same working directory.
#'
#'  @param years a vector of integer year values (YYYY)
#'  @inheritParams fars_read
#'  @inheritParams make_filename
#'
#'  @import dplyr
#'  @import magrittr
#'
#'  @return A tipple of the MONTH and YEAR values for each data file in the \code{years} range
#'  @examples
#'  \dontrun{
#'  fars_read_years(c(2013:2015))
#'  }
#'
#'  @export
fars_read_years <- function(years) {
        lapply(years, function(year) {
                file <- make_filename(year)
                tryCatch({
                  print(file)
                        dat <- fars_read(file)
                        dplyr::mutate(dat, year = year) %>%
                                dplyr::select(MONTH, year)
                }, error = function(e) {
                        warning("invalid year: ", year)
                        return(NULL)
                })
        })
}

#' Summary statistics
#'
#' This function provides summary monthly statistics for each year in a range
#'
#' @details This function uses the output from \code{\link{fars_read_years}}
#' to generate summary accident statistics by \code{YEAR} and \code{MONTH}.
#'
#' @inheritParams fars_read_years
#'
#' @return table of summary statistics
#'
#' @import dplyr
#' @importFrom tidyr spread
#'
#' @examples
#' \dontrun{
#' fars_summarize_years(c(2013:2015))
#' }
#'
#' @export
fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dplyr::bind_rows(dat_list) %>%
                dplyr::group_by(year, MONTH) %>%
                dplyr::summarize(n = n()) %>%
                tidyr::spread(year, n)
}

#' Map Accidents
#'
#' This function maps accidents in individual U.S. State in a given year
#'
#' @details For a given year value, this function read the relevant data file
#' using the \code{\link{make_filename}} and \code{\link{fars_read}} functions.
#' It checks that the stae exists and that any accidents were reported that year in that state.
#' The function also removes erroneous longotude and lattitudes entries in the raw data
#' (\code{longitude>900} and \code{lattitude>90}) and uses the \code{\link{map}} package to
#' draw the relevant map and the \code{\link{graphics}} package to plot dots.
#'
#' @param state.num the unique identification of a U.S. state
#' @param year relevant data year
#' @inheritParams fars_read
#' @inheritParams make_filname
#'
#' @import maps
#' @importFrom dplyr filter
#' @importFrom graphics points
#'
#' @return a long/lat plot of reported accidents in the U.S. state and year of choice against a state boundary map
#'
#' @examples
#' \dontrun{
#' fars_map_state("12","2013")
#' }
#'
#' @export
fars_map_state <- function(state.num, year) {
        filename <- make_filename(year)
        data <- fars_read(filename)
        state.num <- as.integer(state.num)

        if(!(state.num %in% unique(data$STATE)))
                stop("invalid STATE number: ", state.num)
        data.sub <- dplyr::filter(data, STATE == state.num)
        if(nrow(data.sub) == 0L) {
                message("no accidents to plot")
                return(invisible(NULL))
        }
        is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
        is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
        with(data.sub, {
                maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
                          xlim = range(LONGITUD, na.rm = TRUE))
                graphics::points(LONGITUD, LATITUDE, pch = 46)
        })
}
