install.packages("tm")  
install.package("SnowballC") 
install.packages("wordcloud") 
install.packages("RColorBrewer") 

library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")

# Lendo o arquivo
arquivo <- "http://www.sthda.com/sthda/RDoc/example-files/martin-luther-king-i-have-a-dream-speech.txt"
texto <- readLines(arquivo)

# Carregando os dados como Corpus
docs <- Corpus(VectorSource(texto))

# Pré-processamento
inspect(docs)
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")

# Converte o texto para minúsculo
docs <- tm_map(docs, content_transformer(tolower))

# Remove números
docs <- tm_map(docs, removeNumbers)

# Remove as palavras mais comuns do idioma inglês
docs <- tm_map(docs, removeWords, stopwords("english"))

# Você pode definir um vetor de palavras (stopwords) a serem removidas do texto
docs <- tm_map(docs, removeWords, c("blabla1", "blabla2")) 

# Remove pontuação
docs <- tm_map(docs, removePunctuation)

# Elimina espaços extras
docs <- tm_map(docs, stripWhitespace)

# Text stemming
docs <- tm_map(docs, stemDocument)


dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)

# wordcloud
set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))


# Tabela de frequência
findFreqTerms(dtm, lowfreq = 4)
findAssocs(dtm, terms = "freedom", corlimit = 0.3)
head(d, 10)

# Gráficos de barras com as palavras mais frequentes
barplot(d[1:10,]$freq, las = 2, names.arg = d[1:10,]$word,
        col ="lightblue", main ="Most frequent words",
        ylab = "Word frequencies")