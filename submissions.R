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
# RPostgres::dbGetQuery(db_con, "alter table submission add last_update timestamp default current_timestamp")
# RPostgres::dbReadTable(db_con, 'submission')
# RPostgres::dbRemoveTable(db_con, "submission")

# test <- submitIssue('myTitle', 'myBody', 'myPriority', 'myDifficulty', 'ben')
# test2 <- judgeIssue(2, 'rejected', 'benjamin', 'awful id')

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

judgeIssue <- function(id, status, approver, note){
  db_con <- connect2DB()
  
  qry <- paste0(
    "UPDATE submission ",
    "SET status = '", status,"', ",
    "approver = '", approver,"', ",
    "note = '", note,"' ",
    "WHERE id = ", id," RETURNING *;"
  )
  
  info <- RPostgres::dbGetQuery(db_con, qry)
  
  RPostgres::dbDisconnect(db_con)
  
  return(info)
}
  
  


