library(anytime)
library(jsonlite)
library(data.table)

# download.file('https://www.irs.gov/pub/irs-soi/14zpdoc.doc',
#               destfile = 'income_by_zip_layout.doc')
d_get = function(year){
  if (year == 2014){
    url_2014 = "https://www.irs.gov/pub/irs-soi/14zpallagi.csv"
    d_2014 = read.csv(url_2014)
    save(d_2014,
         file = 'd_2014.RData')
  }
}

d_load = function(year) {
  v = load(sprintf("d_%d.RData", year))
  data.table(get(v))
  }

d = d_load(2014)