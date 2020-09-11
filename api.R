# https://github.com/rstudio/plumber/issues/418

source('utils.R')
source('git_oauth.R')
source('auth_db.R')
source('submissions.R')
source('follow_task.R')

#* @filter cors
cors <- function(res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  plumber::forward()
}

#' @get /my-oauth
#' @param code
#' @html
gitOauth

#' @post /addAuth
#' @param token GitHup user token
#' @param admin admin who is submittint a new user
#' @param user github handle of new user
#' @param type type of authorization [admin, reviewer, user]
addAuthorization
  
#' @get /auth
#' @serializer unboxedJSON
#' @param email
getAuthorization

#' @post /editAuth
#' @param token GitHub user token
#' @param admin admin who is edditing user role
#' @param user github handle of user whose role is being edite
#' @param type new authorization type for user [admin, reviewer, user]
editAuthorization

#' @post /submitIssue
#' @param title string title of task
#' @param author handle of author submitting task
#' @param body string of description
#' @param impact string of impact
#' @param timeline string of how long to expect
#' @param priority Priority_Low, Priority_Medium, Priority_High
#' @param complexity Complexity_Low, Complexity_Medium, Complexity_High
#' @param assignees single string for potential help
#' @param repo potential repo for task
submitIssue

#' @post /judgeIssue
#' @param token
#' @param id
#' @param status
#' @param approver
#' @param note
#' @param complexity
#' @param priority
#' @param repo
judgeIssue

#' @get /issues
#' @param status
issues

#' @get /myIssues
#' @param user
myIssues

#' @get /tasks
#' @param user
serveTasks

#' @get /follow
#' @param issue_id
#' @param username
#' @param status
followTasks

#' @serializer unboxedJSON
#' @get /test
sanityCheck
