# #https://gist.github.com/hrbrmstr/45c67103a9728f59212cd13262adca74
# 
# db_con <- connect2DB()
# RPostgres::dbRemoveTable(db_con, "admin")
# admin <- tibble::tibble(username = 'benjaminortizulloa', type = 'admin', approver="benjaminortizulloa")
# RPostgres::dbListTables(db_con)
# RPostgres::dbWriteTable(db_con, 'admin', admin)
# RPostgres::dbGetQuery(db_con, 'alter table admin add id serial;')
# RPostgres::dbGetQuery(db_con, "alter table admin add created_on timestamp default current_timestamp")
# RPostgres::dbGetQuery(db_con, "alter table admin add last_update timestamp default current_timestamp")
# RPostgres::dbReadTable(db_con, 'admin')

# test <- addAuthorization('0bd90cf7bd33424cf726e899dc591a1cd9fca443', 'benjaminortizulloa', 'beemyfriend', 'admin')
# test2 <- editAuthorization('0bd90cf7bd33424cf726e899dc591a1cd9fca443', 'benjaminortizulloa', 'beemyfriend', 'reviewer')
# test3 <- getAuthorization('beemyfriend')
# test4 <- getAuthorization()

pullAuthorization <- function(db_con, user){
  qry <- paste0(
    "SELECT * FROM admin WHERE username = '",
    user,
    "'"
  )
  
  info <- RPostgres::dbGetQuery(db_con, qry)
  return(info)
}

#Need admin rights to main project
#will use personal for now
addGitCollab <- function(token, username, type){
  print('addGitCollab')
  
  permission <- "pull"
  
  if(type == 'admin' | type == "reviewer"){
    permission <- "admin"
  }
  
  ## 'maintain' only works for organization owned repos
  # if(type =="reviewer"){
  #   permission <- "maintain"
  # }
  
  bdy <- jsonlite::toJSON(list(permission = permission), auto_unbox = T)
  print(bdy)

  url = paste0("https://api.github.com/repos/", "benjaminortizulloa", "/", "ExploreGitAPI", "/collaborators/", username)
  print(url)
  
  tkn = paste('token', token)

  config <- httr::add_headers(Authorization = tkn, Accept = "application/vnd.github.v3+json")
  print(config)
  
  postres <- httr::PUT(url,
                       config = config,
                       body = bdy)
  
  print(postres)
  print(httr::content(postres))
  httr::content(postres)
}

removeGitCollab <- function(token, username){
  url = paste0("https://api.github.com/repos/", "benjaminortizulloa", "/", "ExploreGitAPI", "/collaborators/", username)
  print(url)
  
  tkn = paste('token', token)
  config <- httr::add_headers(Authorization = tkn, Accept = "application/vnd.github.v3+json")
  
  postres <- httr::DELETE(url, config = config)

  print(postres)
  print(httr::content(postres))
  httr::content(postres)
}

# reviewer can approve issues and assign issues
# admin same as reviewer but can add new reviewer admin
# user is default...no priveledges
addAuthorization <- function(token, admin, user, type){
  db_con <- connect2DB()
  
  is_recorded <- nrow(pullAuthorization(db_con, user))
  
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
  
  addGitCollab(token, user, type)
  
  return("User successfully added.")
}

editAuthorization <- function(token, admin, user, type){
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
  
  if(type == 'user'){
    removeGitCollab(token, user)
  } else {
    addGitCollab(token, user, type)
  }
  
  return(info)
}

getAuthorization <- function(user = ""){
  db_con <- connect2DB()
  
  if(user == "" ){
    info <- RPostgres::dbReadTable(db_con, 'admin')
    RPostgres::dbDisconnect(db_con)
    return(info)
  }
  
  info <- pullAuthorization(db_con, user)
  
  if(nrow(info) <= 0){
    auth <- list(user=user, type = "user")
  } else {
    auth <- list(user = user ,type = info$type[1])
  }
  
  RPostgres::dbDisconnect(db_con)
  
  return(auth)
}
