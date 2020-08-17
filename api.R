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

#' @post /submitIssue
#' @param owner
#' @param repo
#' @param title
#' @param body
#' @param priority
#' @param difficulty
#' @param author
submitIssue

#' @post /judgeIssue
#' @param token
#' @param id
#' @param status
#' @param approver
#' @param note
judgeIssue

#' @get /issues
#' @param status
issues

#' @serializer unboxedJSON
#' @get /test
sanityCheck
