# https://github.com/rstudio/plumber/issues/418

source('utils.R')
source('git_oauth.R')
source('auth_db.R')
source('submissions.R')

#* @filter cors
cors <- function(res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  plumber::forward()
}

#' @get /my-oauth
#' @param code
#' @html
gitOauth

#' @get /auth
#' @serializer unboxedJSON
#' @param email
getAuthorization

#' @get /submitIssue title, body, priority, difficulty, author
#' @param title
#' @param body
#' @param priority
#' @param difficulty
#' @param author
submitIssue



#' @serializer unboxedJSON
#'@get /test
sanityCheck


