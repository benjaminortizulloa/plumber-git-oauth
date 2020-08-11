gitOauth <- function(code, req, res) {
  gr <- list(client_id = id, client_secret = secret, code = code)
  postres <- httr::POST(url, body = gr)
  
  # login_url <- paste0('http://localhost:8080/#/login/', httr::content(postres)$access_token)
  login_url <- paste0('https://infallible-meitner-feacd3.netlify.app/#/login/', httr::content(postres)$access_token)
  
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