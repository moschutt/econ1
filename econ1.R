library(anytime)
library(jsonlite)
library(data.table)
library(httr)

# Data from https://catalog.data.gov/dataset/zip-code-data
# download.file('https://www.irs.gov/pub/irs-soi/14zpdoc.doc',
#               destfile = 'income_by_zip_layout.doc')
d_get = function(year){
  myvar = sprintf("d_%d", year)
  url = if (year > 2010 ) sprintf("https://www.irs.gov/pub/irs-soi/%dzpallagi.csv",
                                  year - 2000)
  else  {
    u = sprintf("https://www.irs.gov/pub/irs-soi/%dzipcode.zip",
                year)
    zfile = basename(parse_url(u)$path)
    if ( ! file.exists(zfile) ) download.file(u, zfile)
    csvfile = if ( year > 2008 ) {
      sprintf("%2.2dzpallagi.csv", (year - 2000))
    } else if ( year == 2008 ) {
      sprintf("%dZIPCode/%2.2dzpall.csv", 
              year,
              (year - 2000))
    } else if ( year <= 2007 ) {
      sprintf("zipcode%2.2d.csv", 
              (year - ifelse(year >= 2000, 2000, 1900)))
    }
    
    write.csv(read.csv(unz(zfile, csvfile)), 
              row.names = FALSE, 
              file=basename(csvfile))
    basename(csvfile)
  }
  
  print(url)
  assign(myvar,
         read.csv(url))
  save(list=c(myvar),
       file = d_file(year))
}

d_file = function(year) {
  sprintf("d_%d.RData", year)
}

d_load = function(year,
                  refresh=FALSE) {
  if ( ! file.exists(d_file(year)) || 
       refresh ) {
    d_get(year)
  }
  data.table(get(load(d_file(year))))
}