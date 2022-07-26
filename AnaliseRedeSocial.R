# Análise de Dados de Redes Sociais

## Etapa 1 - Pacotes e Autenticação

# Instalando e Carregando o Pacote twitteR
install.packages("twitteR")
install.packages("httr")
library(twitteR)
library(httr)

# Definindo o diretório de trabalho
setwd("/opt/DSA/Projetos/Projeto01")
setwd("C:/DSA/Projetos/Projeto01")

# Criando autenticação no Twitter
key <- "QBJmNzhy41vRLP60CMAFsaufv"
secret <- "8s42HZPMixxHaijGxQJHMMiKkaQBVvkAR52uykWABvdsycNLYh"
token <- "703383646602981377-RXk1xxKHf57HHBvg7URRLEAlQ89KBmE"
tokensecret <- "vTDR1hwYBCBGv95aGTRMpxIoC8K0jcy93qvFUnKlh94Do"

# Autenticação. Responda 1 quando perguntado sobre utilizar direct connection.
setup_twitter_oauth(key, secret, token, tokensecret)


## Etapa 2 - Conexão e captura dos tweets

# Verificando a timeline do usuário
userTimeline("dsacademybr")

# Capturando os tweets
tweetdata = searchTwitter("#BigData", n = 100)

# Visualizando as primeiras linhas do objeto tweetdata
head(tweetdata)


## Etapa 3 - Tratamento dos dados coletados através de text mining

# Instalando o pacote para Text Mining.
install.packages("tm")
install.packages("SnowballC")
library(SnowballC)
library(tm)

# Tratamento (limpeza, organização e transformação) dos dados coletados
tweetlist <- sapply(tweetdata, function(x) x$getText())
tweetcorpus <- Corpus(VectorSource(tweetlist))
tweetcorpus <- tm_map(tweetcorpus, removePunctuation)
tweetcorpus <- tm_map(tweetcorpus, content_transformer(tolower))
tweetcorpus <- tm_map(tweetcorpus, function(x)removeWords(x, stopwords()))

# Convertendo o objeto Corpus para texto plano
tweetcorpus <- tm_map(tweetcorpus, PlainTextDocument)


## Etapa 4 - Wordcloud, associação entre as palavras e dendograma

# Instalando o pacote wordcloud
install.packages("RColorBrewer")
install.packages("wordcloud")
library(RColorBrewer)
library(wordcloud)

# Gerando uma nuvem palavras
pal2 <- brewer.pal(8,"Dark2")
wordcloud(tweetcorpus, 
          min.freq = 4, 
          scale = c(5,1), 
          random.color = F, 
          max.word = 60, 
          random.order = F,
          colors = pal2)

# Convertendo o objeto texto para o formato de matriz
tweettdm <- TermDocumentMatrix(tweetcorpus)
tweettdm

# Encontrando as palavras que aparecem com mais frequência
findFreqTerms(tweettdm, lowfreq = 11)

# Buscando associações
findAssocs(tweettdm, 'datascience', 0.60)

# Removendo termos esparsos (não utilizados frequentemente)
tweet2tdm <-removeSparseTerms(tweettdm, sparse = 0.9)

# Criando escala nos dados
tweet2tdmscale <- scale(tweet2tdm)

# Distance Matrix
tweetdist <- dist(tweet2tdmscale, method = "euclidean")

# Preprando o dendograma
tweetfit <- hclust(tweetdist)

# Criando o dendograma (verificando como as palvras se agrupam)
plot(tweetfit)

# Verificando os grupos
cutree(tweetfit, k = 6)

# Visualizando os grupos de palavras no dendograma
rect.hclust(tweetfit, k = 6, border = "red")


## Etapa 5 - Análise de Sentimento

# Criando uma função para avaliar o sentimento
install.packages("stringr")
install.packages("plyr")
library(stringr)
library(plyr)

sentimento.score = function(sentences, pos.words, neg.words, .progress = 'none')
{
  
  # Criando um array de scores com lapply
  scores = laply(sentences,
                 function(sentence, pos.words, neg.words)
                 {
                   sentence = gsub("[[:punct:]]", "", sentence)
                   sentence = gsub("[[:cntrl:]]", "", sentence)
                   sentence =gsub('\\d+', '', sentence)
                   tryTolower = function(x)
                   {
                     y = NA
                     try_error = tryCatch(tolower(x), error=function(e) e)
                     if (!inherits(try_error, "error"))
                       y = tolower(x)
                     return(y)
                   }
                   
                   sentence = sapply(sentence, tryTolower)
                   word.list = str_split(sentence, "\\s+")
                   words = unlist(word.list)
                   pos.matches = match(words, pos.words)
                   neg.matches = match(words, neg.words)
                   pos.matches = !is.na(pos.matches)
                   neg.matches = !is.na(neg.matches)
                   score = sum(pos.matches) - sum(neg.matches)
                   return(score)
                 }, pos.words, neg.words, .progress = .progress )
  
  scores.df = data.frame(text = sentences, score = scores)
  return(scores.df)
}

# Mapeando as palavras positivas e negativas
pos = readLines("palavras_positivas.txt")
neg = readLines("palavras_negativas.txt")

# Criando massa de dados para teste
teste = c("Big Data is the future", "awesome experience",
          "analytics could not be bad", "learn to use big data")

# Testando a função em nossa massa de dados dummy
testesentimento = sentimento.score(teste, pos, neg)
class(testesentimento)

# Verificando o score
# 0 - expressão não possui palavra em nossas listas de palavras positivas e negativas ou
# encontrou uma palavra negativa e uma positiva na mesma sentença
# 1 - expressão possui palavra com conotação positiva 
# -1 - expressão possui palavra com conotação negativa
testesentimento$score


## Etapa 6 - Gerando Score da Análise de Sentimento

# Tweets por país
catweets = searchTwitter("ca", n = 500, lang = "en")
usatweets = searchTwitter("usa", n = 500, lang = "en")

# Obtendo texto
catxt = sapply(catweets, function(x) x$getText())
usatxt = sapply(usatweets, function(x) x$getText())

# Vetor de tweets dos países
paisTweet = c(length(catxt), length(usatxt))

# Juntando os textos
paises = c(catxt, usatxt)

# Aplicando função para calcular o score de sentimento
scores = sentimento.score(paises, pos, neg, .progress = 'text')

# Calculando o score por país
scores$paises = factor(rep(c("ca", "usa"), paisTweet))
scores$muito.pos = as.numeric(scores$score >= 1)
scores$muito.neg = as.numeric(scores$score <= -1)

# Calculando o total
numpos = sum(scores$muito.pos)
numneg = sum(scores$muito.neg)

# Score global
global_score = round( 100 * numpos / (numpos + numneg) )
head(scores)
boxplot(score ~ paises, data = scores)

# Gerando um histograma com o lattice
install.packages("lattice")
library("lattice")
histogram(data = scores, ~score|paises, main = "Análise de Sentimentos", xlab = "", sub = "Score")



## Usando Classificador Naive Bayes para analise de sentimento
# https://cran.r-project.org/src/contrib/Archive/Rstem/
# https://cran.r-project.org/src/contrib/Archive/sentiment/

install.packages("/opt/DSA/Projetos/Projeto01/Rstem_0.4-1.tar.gz", repos = NULL, type = "source")
install.packages("/opt/DSA/Projetos/Projeto01/sentiment_0.2.tar.gz", repos = NULL, type = "source")
install.packages("ggplot2")
library(Rstem)
library(sentiment)
library(ggplot2)

# Coletando os tweets
tweetpt = searchTwitter("bigdata", n = 1500, lang = "pt")

# Obtendo o texto
tweetpt = sapply(tweetpt, function(x) x$getText())

# Removendo caracteres especiais
tweetpt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", tweetpt)
# Removendo @
tweetpt = gsub("@\\w+", "", tweetpt)
# Removendo pontuação
tweetpt = gsub("[[:punct:]]", "", tweetpt)
# Removendo digitos
tweetpt = gsub("[[:digit:]]", "", tweetpt)
# Removendo links html
tweetpt = gsub("http\\w+", "", tweetpt)
# Removendo espacos desnecessários
tweetpt = gsub("[ \t]{2,}", "", tweetpt)
tweetpt = gsub("^\\s+|\\s+$", "", tweetpt)

# Criando função para tolower
try.error = function(x)
{
  # Criando missing value
  y = NA
  try_error = tryCatch(tolower(x), error=function(e) e)
  if (!inherits(try_error, "error"))
    y = tolower(x)
  return(y)
}

# Lower case
tweetpt = sapply(tweetpt, try.error)

# Removendo os NAs
tweetpt = tweetpt[!is.na(tweetpt)]
names(tweetpt) = NULL

# Classificando emocao
class_emo = classify_emotion(tweetpt, algorithm = "bayes", prior = 1.0)
emotion = class_emo[,7]

# Substituindo NA's por "Desconhecido"
emotion[is.na(emotion)] = "Desconhecido"

# Classificando polaridade
class_pol = classify_polarity(tweetpt, algorithm = "bayes")
polarity = class_pol[,4]

# Gerando um dataframe com o resultado
sent_df = data.frame(text = tweetpt, emotion = emotion,
                     polarity = polarity, stringsAsFactors = FALSE)

# Ordenando o dataframe
sent_df = within(sent_df,
                 emotion <- factor(emotion, levels = names(sort(table(emotion), 
                                                                decreasing=TRUE))))


# Emoções encontradas
ggplot(sent_df, aes(x = emotion)) +
  geom_bar(aes(y = ..count.., fill = emotion)) +
  scale_fill_brewer(palette = "Dark2") +
  labs(x = "Categorias", y = "Numero de Tweets") 

# Polaridade
ggplot(sent_df, aes(x=polarity)) +
  geom_bar(aes(y=..count.., fill=polarity)) +
  scale_fill_brewer(palette="RdGy") +
  labs(x = "Categorias de Sentimento", y = "Numero de Tweets")











