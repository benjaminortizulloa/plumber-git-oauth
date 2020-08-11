url <- Sys.getenv("GITHUB_AUTH_ACCESSTOKEN_URL")
id <- Sys.getenv("CLIENT_ID")
secret <- Sys.getenv("CLIENT_SECRET")
pg_auth <- Sys.getenv("PG_AUTH")

sanityCheck <- function(){
  return('sanity check')
}
