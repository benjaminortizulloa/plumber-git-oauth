### .Renviron file

```
RECON_URL_DEV = "http://localhost:8080"
RECON_URL_PROD = "production-website"
GITHUB_AUTH_ACCESSTOKEN_URL = 'https://github.com/login/oauth/access_token'
CLIENT_ID = "github-provided-client-id"
CLIENT_SECRET = "github-provided-client-secret"
PG_AUTH = "postgres_important_string_connection"
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