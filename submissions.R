# submissions <- tibble::tibble(
#   title = character(0),
#   body = character(0),
#   priority = character(0),
#   difficulty = character(0),
#   author = character(0),
#   status = character(0),
#   approver = character(0),
#   note = character(0)
# )

# db_con <- connect2DB()
# RPostgres::dbListTables(db_con)
# RPostgres::dbWriteTable(db_con, 'submission', submissions)
# RPostgres::dbGetQuery(db_con, 'alter table submission add id serial;')
# RPostgres::dbGetQuery(db_con, "alter table submission add created_on timestamp default current_timestamp")
# RPostgres::dbGetQuery(db_con, "alter table submission add last_update timestamp default current_timestamp")
RPostgres::dbReadTable(db_con, 'submission')
# RPostgres::dbRemoveTable(db_con, "submission")
# 
# test <- submitIssue('myTitle', 'myBody', 'myPriority', 'myDifficulty', 'ben')
# test2 <- judgeIssue(1, 'rejected', 'benjamin', 'awful id')

# submit issue for admins to approve
submitIssue <- function(title, body, priority, difficulty, author){
  db_con <- connect2DB()
  
  qry <- paste0(
    "INSERT INTO submission(title, body, priority, difficulty, author, status) ",
    "VALUES ('", 
    paste(title, body, priority, difficulty, author, "pending",  sep = "', '"),
    "') RETURNING *;"
  )
  
  info <- RPostgres::dbGetQuery(db_con, qry)
  
  RPostgres::dbDisconnect(db_con)
  
  return(info)
}

# approve or reject submitted issues
judgeIssue <- function(token, id, status, approver, note){
  db_con <- connect2DB()
  
  qry <- paste0(
    "UPDATE submission ",
    "SET status = '", status,"', ",
    "approver = '", approver,"', ",
    "note = '", note,"', ",
    "last_update = current_timestamp ",
    "WHERE id = ", id," RETURNING *;"
  )
  
  info <- RPostgres::dbGetQuery(db_con, qry)
  info <- list(info = info)
  
  if(status == 'approved'){
    gitRes <- postIssue(token, info$title[1], info$body[1], info$priority[1], info$difficulty[1])
    info$gitRes <- gitRes
  }
  
  RPostgres::dbDisconnect(db_con)
  
  return(info)
}

#' get issues by status
issues <- function(status){
  db_con <- connect2DB()
  
  qry <- paste0("SELECT * FROM submission WHERE status = '", status, "'")
  
  statuses <- RPostgres::dbGetQuery(db_con, qry)
  
  RPostgres::dbDisconnect(db_con)
  
  return(statuses)
}

postIssue <- function(token, title, body, priority, difficulty){
  print('postIssue')
  bdy <- jsonlite::toJSON(list(title = title, body = body, labels = c(priority, difficulty)), auto_unbox = T)
  url = "https://api.github.com/repos/BenjaminOrtizUlloa/ExploreGitAPI/issues"
  tkn = paste('token', token)
  postres <- httr::POST(url, httr::add_headers(Authorization = tkn), body = bdy)
  httr::content(postres)
}