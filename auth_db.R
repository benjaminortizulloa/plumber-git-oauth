#https://gist.github.com/hrbrmstr/45c67103a9728f59212cd13262adca74

# db_con <- connect2DB()
# RPostgres::dbRemoveTable(db_con, "admin")
# admin <- tibble::tibble(username = 'benjaminortizulloa', type = 'admin', approver="benjaminortizulloa")
# RPostgres::dbListTables(db_con)
# RPostgres::dbWriteTable(db_con, 'admin', admin)
# RPostgres::dbGetQuery(db_con, 'alter table admin add id serial;')
# RPostgres::dbGetQuery(db_con, "alter table admin add created_on timestamp default current_timestamp")
# RPostgres::dbGetQuery(db_con, "alter table admin add last_update timestamp default current_timestamp")
# RPostgres::dbReadTable(db_con, 'admin')
# 
 # test <- addAuthorization('benjaminortizulloa', 'beemyfriend', 'admin')
 # test2 <- editAuthorization('benjaminortizulloa', 'beemyfriend', 'reviewer')
# test3 <- getAuthorization('benjaminortizulloa')
 # test4 <- getAuthorization()

pullAuthorization <- function(user){
  qry <- paste0(
    "SELECT * FROM admin WHERE username = '",
    user,
    "'"
  )
  
  info <- RPostgres::dbGetQuery(db_con, qry)
  return(info)
}

# reviewer can approve issues and assign issues
# admin same as reviewer but can add new reviewer admin
# user is default...no priveledges
addAuthorization <- function(admin, user, type){
  db_con <- connect2DB()
  
  is_recorded <- nrow(pullAuthorization(user))
  
  if(is_recorded != 0){
    return("User already exists.")
  }
  
  qry <- paste0(
    "INSERT INTO admin(username, type, approver) ",
    "VALUES ('", 
    paste(stringr::str_replace_all(c(user, type, admin), "'", "''"),  collapse = "', '"),
    "') RETURNING *;"
  )
  
  info <- RPostgres::dbGetQuery(db_con, qry)

  RPostgres::dbDisconnect(db_con)
  
  return("User successfully added.")
}

editAuthorization <- function(admin, user, type){
  db_con <- connect2DB()
  
  qry <- paste0(
    "UPDATE admin ",
    "SET type = '", type,"', ",
    "approver = '", admin, "', ",
    "last_update = current_timestamp ",
    "WHERE username = '", user, "' RETURNING *;"
  )
  
  info <- RPostgres::dbGetQuery(db_con, qry)
  
  RPostgres::dbDisconnect(db_con)
  
  return(info)
}

getAuthorization <- function(user = ""){
  db_con <- connect2DB()
  
  if(user == "" ){
    info <- RPostgres::dbReadTable(db_con, 'admin')
    RPostgres::dbDisconnect(db_con)
    return(info)
  }
  
  info <- pullAuthorization(user)
  
  if(nrow(info) <= 0){
    auth <- list(user=user, type = "user")
  } else {
    auth <- list(user = user ,type = info$type[1])
  }
  
  RPostgres::dbDisconnect(db_con)
  
  return(auth)
}
