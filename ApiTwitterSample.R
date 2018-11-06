# Bibliotecas Necessárias
library(twitteR)
library(janeaustenr)
library(dplyr)
library(stringr)
library(tidytext)

#Limpa variáveis
result_text = NULL
result_words = NULL
cleaned_twitts = NULL
word_count = NULL

# Diretório onde serão depositados os arquivos
setwd("C:/Users/filip/OneDrive/Documentos/R/Data")

# Passando parâmetros de Autorizacao da API: consumer-key, consumer-secret, access-token, access-secret
setup_twitter_oauth(
  "WB2rYeu8aWDhYsuSraW79NtsD",
  "3KjvRFAy2FaJDUuobWVorW7I7pbFmV0cciXMZB08SNZrYhuwHJ",
  "1041048259052167169-si5AVGLaIimwScKkAxISCZyCMYo0qb",
  "yU25lo80OTb0LkZCf9OpWeUtDuBImcTua5oVwGR5nFiPF"
)

# Termo da pesquisa
terms <-
  c("homeschooling")

terms_search <- paste(terms, collapse = " OR ")

# Inicia Pesquisa no Twitter
result_search <-
  searchTwitter(
    terms_search,
    n = 1000,
    lang = "en",
    since = "2018-11-05",
    until = "2018-11-06"
  )

result_search = strip_retweets(result_search)

if (length(result_search) ==
    0) {
  print("Nenhum registro encontrado.")
} else {
  # Jogando resultado em uma tabela
  result_search <- twListToDF(result_search)
  
  result_text <- result_search[, c(8, 1)]
  
  # Escreve resultado em arquivo CSV
  write.table(
    result_search,
    "result_search.csv",
    append = F,
    row.names = F,
    col.names = T,
    sep = ","
  )
  
  ################### Análise de Text Mining
  # https://cran.r-project.org/web/packages/tidytext/vignettes/tidytext.html
  # https://www.tidytextmining.com/sentiment.html
  
  # Passa de Coluna para linhas
  result_words <- result_text %>%
    unnest_tokens(word, text)
  
  # Retira stop words
  cleaned_twitts <- result_words %>%
    anti_join(get_stopwords())
  
  # Conta palavras mais usadas
  word_count <- cleaned_twitts %>%
    count(word, sort = TRUE)
  
  #nrcjoy <- get_sentiments("bing") %>%
  #  filter(sentiment == "joy")
  
  #tidy_books %>%
  #  filter(book == "Emma") %>%
  #  semi_join(nrcjoy) %>%
  #  count(word, sort = TRUE)
}