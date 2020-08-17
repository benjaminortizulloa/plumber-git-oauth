gitOauth <- function(code, req, res) {
  gr <- list(client_id = id, client_secret = secret, code = code)
  postres <- httr::POST(url, body = gr)
  
  print(gr)
  
  login_url <- paste0(web, '/#/login/', httr::content(postres)$access_token)
  
  print('login_url')
  print(login_url)
  
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