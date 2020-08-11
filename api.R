# https://github.com/rstudio/plumber/issues/418

source('utils.R')
source('git_oauth.R')
source('auth_db.R')

#' @get /my-oauth
#' @param code
#' @html
gitOauth

#' @get /auth
#' @param email
getAuthorization

#'@get /test
sanityCheck


