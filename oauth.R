# https://github.com/rstudio/plumber/issues/418

url <- Sys.getenv("GITHUB_AUTH_ACCESSTOKEN_URL")
id <- Sys.getenv("CLIENT_ID")
secret <- Sys.getenv("CLIENT_SECRET")

print(paste('url', url))
print(paste('id', id))
print(paste('secret', secret))

#' @get /my-oauth
#' @param code
#' @html
function(code, req, res) {
  gr <- list(client_id = id, client_secret = secret, code = code)
  postres <- httr::POST(url, body = gr)

  login_url <- paste0('http://localhost:8080/login?access_token=', httr::content(postres)$access_token)

  res$status <- 303 # redirect
  res$setHeader("Location", login_url)
  
  paste0("<html>
  <head>
  <meta http-equiv=\"Refresh\" content=\"0; url=", login_url, "\" />
  </head>
  <body>
  <p>Please follow <a href=\"http://www.example.com/\">this link</a>.</p>
  </body>
  </html>")
}

#'@get /test
function(){
  return('sanity check')
}