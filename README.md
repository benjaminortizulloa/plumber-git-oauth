### .Renviron file

```
GITHUB_AUTH_ACCESSTOKEN_URL = 'https://github.com/login/oauth/access_token'
CLIENT_ID = "github-provided-client-id"
CLIENT_SECRET = "github-provided-client-secret"
```

### docker launch

```
docker build -t plumber-test .
docker run --rm -p 3000:3000 plumber-test
```