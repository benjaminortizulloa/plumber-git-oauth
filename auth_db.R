#https://gist.github.com/hrbrmstr/45c67103a9728f59212cd13262adca74

#admin <- tibble::tibble(username = 'benjaminortizulloa', type = 'admin')

getAuthorization <- function(user){
  db_con <- connect2DB()
  
  qry <- paste0(
    "SELECT * FROM admin WHERE username = '",
    user,
    "'"
  )
  
  info <- RPostgres::dbGetQuery(db_con, qry)
  
  if(nrow(info) <= 0){
    auth <- list(user=user, type = "user")
  } else {
    auth <- list(user = user ,type = info$type[1])
  }
  
  RPostgres::dbDisconnect(db_con)
  
  return(auth)
}
