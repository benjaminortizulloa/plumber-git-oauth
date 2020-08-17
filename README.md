### .Renviron file

```
RECON_URL_TYPE = "prod"
RECON_URL_DEV = "http://localhost:8080"
CLIENT_ID_DEV = ""
CLIENT_SECRET_DEV = ""
RECON_URL_PROD = "https://infallible-meitner-feacd3.netlify.app"
CLIENT_ID_PROD = ""
CLIENT_SECRET_PROD = ""
GITHUB_AUTH_ACCESSTOKEN_URL = 'https://github.com/login/oauth/access_token'
PG_AUTH = ""
```

### docker launch

```
docker build -t plumber-test .
docker run --rm -p 3000:3000 plumber-test
```

### heroku launch

```
heroku apps
heroku container:push web
heroku container:release web
heroku open
```