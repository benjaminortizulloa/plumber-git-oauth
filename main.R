if(Sys.getenv("PORT") == "") Sys.setenv(PORT = 3000)
plumber::plumb('api.R')$run(port=as.numeric(Sys.getenv("PORT")), host="0.0.0.0", swagger = T)

