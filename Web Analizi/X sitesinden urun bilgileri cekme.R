##kutuphaneler
library(rvest)
library(purrr)
library(stringr)
library(xml2)
library(dplyr)
library(urltools)
library(lubridate)
library(RSQLite)
library(tuber)
library(openxlsx)
library(stringi)
library(tm)
###Turkiye' En cok Satalanlar

url_tr <- "https://www.amazon.com.tr/s?rh=n%3A21675904031&fs=true&ref=lp_21675904031_sar"
webpagetr <- read_html(url_tr, encoding ="UTF-8")

#URUN ISMI
product_names <- webpagetr %>%
  html_nodes(".puis-v1102xfiy6gme925w67f1x0fa3d .s-line-clamp-4") %>%
  html_text(trim = TRUE)

product_names <- stri_trans_general(product_names, "latin-ascii")
print(product_names)


#URUN FIYATI
product_prices_whole <- webpagetr %>%
  html_nodes(".a-price-whole") %>%
  html_text(trim = TRUE)

product_prices_fraction <- webpagetr %>%
  html_nodes(".a-price-fraction") %>%
  html_text(trim = TRUE)
product_prices <- paste(product_prices_whole, product_prices_fraction)
product_prices <- gsub(", ", ",", product_prices)

#BURADA HTML NODES İÇİNE YAZDIKLARIM ŞU ŞEKİLDEDİR: ÖRNEĞİN URUN FIYATININ USTUNE GELİP SAG TIK 
#YAPTIGIMIZDA OGEYI DENETLEYE BASARAK ÇIKAN EKRANDA CLASS ' INI BULUP KOPYALIP YAPISTIRIYORUZ.

#fiyati olmayanlari silme
product_names <- product_names [-30]
product_names <- product_names [-26]
product_names <- product_names [-20]
product_names <- product_names [-25]


#URUN OYLARI
product_rating <- webpagetr %>%
  html_nodes('.a-icon-alt') %>%
  html_text(trim = TRUE)


#df altinda birlestirme
trproducts_df <- data.frame(
  name = product_names,
  price = product_prices,
  rating = product_rating,
  stringsAsFactors = FALSE
)

write.xlsx(trproducts_df,"trproduct.xlsx",row.names = FALSE)
trproducts_df <- read.xlsx(file.choose())