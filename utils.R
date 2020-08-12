web_dev <- Sys.getenv("RECON_URL_DEV")
web_prod <- Sys.getenv("RECON_URL_PROD")
url <- Sys.getenv("GITHUB_AUTH_ACCESSTOKEN_URL")
id <- Sys.getenv("CLIENT_ID")
secret <- Sys.getenv("CLIENT_SECRET")
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
