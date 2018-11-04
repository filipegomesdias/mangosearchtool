#!/usr/local/bin/Rscript

setwd("C:/Users/filip/OneDrive/Documentos/R")

library(twitteR)

# Passando parâmetros de Autorizacao da API: consumer-key, consumer-secret, access-token, access-secret
setup_twitter_oauth("WB2rYeu8aWDhYsuSraW79NtsD", "3KjvRFAy2FaJDUuobWVorW7I7pbFmV0cciXMZB08SNZrYhuwHJ",
                    "1041048259052167169-si5AVGLaIimwScKkAxISCZyCMYo0qb", "yU25lo80OTb0LkZCf9OpWeUtDuBImcTua5oVwGR5nFiPF")

terms1 <- c("ENEN","Enen","enen")
terms_search1 <- paste(terms1, collapse = " OR ")
terms_search1 = paste("(",terms_search1,")")

terms2 <- c("SORTE","Sorte","sorte")
terms_search2 <- paste(terms2, collapse = " OR ")
terms_search2 = paste("(",terms_search2,")")

terms_search = paste(terms_search1, " AND ",terms_search2)

# Inicia Pesquisa no Twitter
result_search <- searchTwitter(terms_search, n=1000, lang="pt")

result_search <- twListToDF(result_search)

# Escreve resultado em arquivo CSV
write.table(result_search,"Data/result_search.csv", append=F, row.names=F, col.names=T,  sep=",")
