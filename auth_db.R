#https://gist.github.com/hrbrmstr/45c67103a9728f59212cd13262adca74

#admin <- tibble::tibble(user = 'ortizulloabenjamin@gmail.com', type = 'admin')
pg <- httr::parse_url(pg_auth)

connect2DB <- function(){
  RPostgres::dbConnect(RPostgres::Postgres(),
                       dbname = trimws(pg$path),
                       host = pg$hostname,
                       port = pg$port,
                       user = pg$username,
                       password = pg$password,
                       sslmode = "require"
  )
}

getAuthorization <- function(email){
  db_con <- connect2DB()
  
  qry <- paste0(
    "SELECT * FROM admin WHERE email = '",
    email,
    "'"
  )
  
  info <- RPostgres::dbGetQuery(db_con, qry)
  
  if(nrow(info) <= 0){
    auth <- list(email=email, type = "user")
  } else {
    auth <- list(email = email ,type = info$type[1])
  }
  
  RPostgres::dbDisconnect(db_con)
  
  return(auth)
}
