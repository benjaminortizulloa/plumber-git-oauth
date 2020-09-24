url_type <- Sys.getenv("RECON_URL_TYPE")
web = ifelse(url_type == 'dev', Sys.getenv("RECON_URL_DEV") ,Sys.getenv("RECON_URL_PROD"))
url <- Sys.getenv("GITHUB_AUTH_ACCESSTOKEN_URL")
id <- ifelse(url_type == 'dev', Sys.getenv("CLIENT_ID_DEV"), Sys.getenv("CLIENT_ID_PROD"))
secret <- ifelse(url_type == 'dev', Sys.getenv("CLIENT_SECRET_DEV"), Sys.getenv("CLIENT_SECRET_PROD"))
pg_auth <- Sys.getenv("PG_AUTH")

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

sanityCheck <- function(){
  return('sanity check')
}

base_scores <- c(
  "Priority Low" = 10,
  "Priority Medium" = 30,
  "Priority High" = 50,
  "Priority Urgent" = 70
)