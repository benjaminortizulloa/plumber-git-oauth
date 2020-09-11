backup_db <- function(){
  db_con <- connect2DB()
  now <- as.numeric(Sys.time()) #origin = "1970-01-01 00:00.00 UTC"
  tbls <- RPostgres::dbListTables(db_con)
  
  lapply(tbls, function(nm){
    tbl <- RPostgres::dbReadTable(db_con, 'submission')
    readr::write_csv(tbl, paste0('backup/', now, '_', nm, '.csv'))
  })
}
