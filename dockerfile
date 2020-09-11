FROM alpine:3.7
RUN apk add postgresql-dev

FROM rocker/r-ver:4.0.2

RUN apt-get update -qq && apt-get install -y \
      libssl-dev \
      libcurl4-gnutls-dev \
      libpq5
      
RUN R -e "install.packages(c('dplyr', 'httr', 'jsonlite', 'plumber', 'RPostgres', 'stringr', 'tibble'))"

COPY / /

EXPOSE 3000

ENTRYPOINT ["Rscript", "main.R"]