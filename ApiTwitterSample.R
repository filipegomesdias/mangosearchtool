##### Análise de Text Mining #####
install.packages("twitteR")
install.packages("janeaustenr")
install.packages("dplyr")
install.packages("stringr")
install.packages("tidytext")
install.packages("tidyr")
install.packages("ggplot2")
install.packages("wordcloud")
install.packages("reshape2")

# Bibliotecas Necessárias
library(twitteR)
library(janeaustenr)
library(dplyr)
library(stringr)
library(tidytext)
library(tidyr)
library(ggplot2)
library(wordcloud)
library(reshape2)

# Limpa Frames
result_text = NULL
result_words = NULL
cleaned_words = NULL
word_count = NULL
sentimento_tbl = NULL
tweets_sentiment = NULL
tweets_sentiment_text = NULL

# Diretório onde serão depositados os arquivos
setwd("C:/Users/filip/OneDrive/Documentos/GitHub/mangosearchtool")

graphic_file_name = paste("sentiment_", as.character(Sys.Date() - 1), ".jpg")

if (file.exists(graphic_file_name)) {
  print(paste("Processo já foi executado para o dia: ", as.character(Sys.Date() - 1)))
} else{
  # Passando parâmetros de Autorizacao da API: consumer-key, consumer-secret, access-token, access-secret
  setup_twitter_oauth(
    "WB2rYeu8aWDhYsuSraW79NtsD",
    "3KjvRFAy2FaJDUuobWVorW7I7pbFmV0cciXMZB08SNZrYhuwHJ",
    "1041048259052167169-si5AVGLaIimwScKkAxISCZyCMYo0qb",
    "yU25lo80OTb0LkZCf9OpWeUtDuBImcTua5oVwGR5nFiPF"
  )
  
  # Termo da pesquisa
  terms <-
    c("homeschooling", "homeschool")
  
  terms_search <- paste(terms, collapse = " OR ")
  
  # Inicia Pesquisa no Twitter
  result_search <-
    searchTwitter(
      terms_search,
      n = 3000,
      lang = "en",
      since = as.character(Sys.Date() - 1),
      until = as.character(Sys.Date())
    )
  
  result_search = strip_retweets(result_search)
  
  if (length(result_search) ==
      0) {
    print("Nenhum registro encontrado.")
  } else {
    # Jogando resultado em uma tabela
    result_search <- twListToDF(result_search)
    
    # Utilizando somente campos necessários
    result_text <- result_search[, c(5, 8, 1)] %>%
      mutate(created = substr(created, 1, 10))
    
    # Muda nome da coluna com a data
    colnames(result_text)[colnames(result_text) == "created"] <-
      "date"
    
    # Passa de Coluna para linhas
    result_words <- result_text %>%
      unnest_tokens(word, text)
    
    # Retira stop words
    cleaned_words <- result_words %>%
      anti_join(get_stopwords())
    
    # Conta palavras mais usadas
    word_count <- cleaned_words %>%
      count(word, sort = TRUE)
    
    # Tabela de sentimento de palavras (negativa ou positiva)
    sentimento_tbl <- get_sentiments("bing")
    
    # Cria tabela de com sentimento dos twitts
    tweets_sentiment <- cleaned_words %>%
      inner_join(sentimento_tbl) %>%
      count(date, id, sentiment) %>%
      spread(sentiment, n, fill = 0) %>%
      mutate(sentiment = positive - negative)
    
    # Mostra resultado de determinado tweet
    tweets_sentiment_text = result_text %>%
      inner_join(tweets_sentiment)
    
    ##### Plota Gráfico do Dia
    ggplot(tweets_sentiment_text, aes(id, sentiment, fill = date)) +
      geom_bar(stat = "identity", show.legend = FALSE) +
      facet_wrap(~ date, ncol = 2, scales = "free_x") +
      ggsave(graphic_file_name)
    

    ##### Agrupamento de Palavras (não salva arquivo)
    cleaned_words %>%
      inner_join(sentimento_tbl) %>%
      count(word, sentiment, sort = TRUE) %>%
      acast(word ~ sentiment, value.var = "n", fill = 0) %>%
      comparison.cloud(colors = c("#F8766D", "#00BFC4"),
                       max.words = 100)
    
    ##### Escreve resultado do dia em arquivo CSV
    write.table(
      tweets_sentiment_text,
      "tweets_sentiment.csv",
      append = T,
      row.names = F,
      col.names = F,
      sep = ";"
    )
  }
}
################### Bibliografia:
# https://cran.r-project.org/web/packages/tidytext/vignettes/tidytext.html
# https://www.tidytextmining.com/sentiment.html
