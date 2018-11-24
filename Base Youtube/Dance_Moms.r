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
setwd("C:/Users/A57029527/Downloads/mangosearchtool-master/mangosearchtool-master")

graphic_file_name = paste("sentiment_", as.character(Sys.Date() - 1), ".jpg")


    result_search <- Dance_Moms_Maddie_and_Mackenzie_Homeschooling
    
    # Passa de Coluna para linhas
    result_words <- result_search %>%
      unnest_tokens(word, comment)
    
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
      count(id, sentiment) %>%
      spread(sentiment, n, fill = 0) %>%
      mutate(sentiment = positive - negative)
    
    # Mostra resultado de determinado tweet
    tweets_sentiment_text = result_search %>%
      inner_join(tweets_sentiment)
    
   # Conta palavras mais usadas
    word_count_sent <- tweets_sentiment_text %>%
      count(sentiment, sort = TRUE)
      
      # Change barplot fill colors by groups
    ggplot(word_count_sent, aes(x=sentiment, y=n, fill=sentiment)) +
      geom_bar(stat="identity")+scale_fill_gradient2(low="red", high="blue")
    
    
    ##### Agrupamento de Palavras (não salva arquivo)
    cleaned_words %>%
      inner_join(sentimento_tbl) %>%
      count(word, sentiment, sort = TRUE) %>%
      acast(word ~ sentiment, value.var = "n", fill = 0) %>%
      comparison.cloud(colors = c("#F8766D", "#00BFC4"),
                       max.words = 100)
    
    

