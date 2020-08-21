# submissions <- tibble::tibble(
#   owner = character(0),
#   repo = character(0),
#   title = character(0),
#   body = character(0),
#   priority = character(0),
#   difficulty = character(0),
#   author = character(0),
#   status = character(0),
#   approver = character(0),
#   note = character(0)
# )
# 
# db_con <- connect2DB()
# RPostgres::dbListTables(db_con)
# RPostgres::dbWriteTable(db_con, 'submission', submissions)
# RPostgres::dbGetQuery(db_con, 'alter table submission add id serial;')
# RPostgres::dbGetQuery(db_con, "alter table submission add created_on timestamp default current_timestamp")
# RPostgres::dbGetQuery(db_con, "alter table submission add last_update timestamp default current_timestamp")
# RPostgres::dbReadTable(db_con, 'submission')
# RPostgres::dbRemoveTable(db_con, "submission")
# 
# test <- submitIssue("benjaminortizulloa", "ExploreGitAPI", 'myTitle', 'myBody', 'myPriority', 'myDifficulty', 'beemyfriend')
# test2 <- judgeIssue('36d5c2d9b392749d5995938d7c39031b577cc42d', 1, 'approved', 'benjaminortizulloa', 'approvingnow')

# submit issue for admins to approve
submitIssue <- function(owner, repo, title, body, priority, difficulty, author){
  db_con <- connect2DB()
  
  qry <- paste0(
    "INSERT INTO submission(owner, repo, title, body, priority, difficulty, author, status, note) ",
    "VALUES ('", 
    paste(stringr::str_replace_all(c(owner, repo, title, body, priority, difficulty, author, "pending", " "), "'", "''"),  collapse = "', '"),
    "') RETURNING *;"
  )
  
  print(qry)
  
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
    "note = '", stringr::str_replace_all(note, "'", "''"),"', ",
    "last_update = current_timestamp ",
    "WHERE id = ", id," RETURNING *;"
  )
  
  info <- RPostgres::dbGetQuery(db_con, qry)
  info <- list(info = info)
  
  if(status == 'approved'){
    gitRes <- postIssue(token, info$info$owner[1], info$info$repo[1], info$info$title[1], info$info$author[1], info$info$body[1], info$info$priority[1], info$info$difficulty[1])
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

myIssues <- function(user){
  db_con <- connect2DB()
  
  qry <- paste0("SELECT * FROM submission WHERE author = '", user, "'")
  
  statuses <- RPostgres::dbGetQuery(db_con, qry)
  
  RPostgres::dbDisconnect(db_con)
  
  return(statuses)
}

postIssue <- function(token, owner, repo, title, author, body,priority, difficulty){
  body = paste0(body, " [originally proposed by @", author, "]")
  print('postIssue')
  bdy <- jsonlite::toJSON(list(title = title, body = body, labels = c(priority, difficulty)), auto_unbox = T)
  print(bdy)
  url = paste0("https://api.github.com/repos/", owner, "/", repo, "/issues")
  print(url)
  tkn = paste('token', token)
  postres <- httr::POST(url, httr::add_headers(Authorization = tkn), body = bdy)
  httr::content(postres)
}
