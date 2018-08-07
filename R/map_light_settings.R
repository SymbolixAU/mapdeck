#' Light Settings
#'
#' List object containg light settings.
#'
#' Available in \link{add_geojson}, \link{add_pointcloud} and \link{add_polygon}
#'
#' \itemize{
#'   \item{numberOfLights - the number of lights. Maximum of 5}
#'   \item{lightsPosition - vector of x, y, z coordinates. Must be 3x the nubmer of lights}
#'   \item{ambientRatio - the ambient ratio of the lights}
#' }
#'
#' @examples
#'
#' light <- list(
#'   lightsPosition = c(-150, 75, 0)
#'   , numberOfLights = 1
#'   , ambientRatio = 0.2
#' )
#'
#' @name light_settings
NULL
