# Analise Exploratoria de Dados

# Definindo o diretorio de trabalho
setwd("/opt/DSA/MachineLearning/BigDataR")

# Carregando o pacote readr
library(readr)

# Carregando o dataset
carros <- read_csv("http://datascienceacademy.com.br/blog/aluno/RFundamentos/Datasets/ML/carros-usados.csv")

# Resumo dos dados
head(carros)
str(carros)

# Medidas de Tendencia Central
summary(carros$ano)
summary(carros[c('preco', 'kilometragem')])


## Explorando variaveis numericas

# Usando as funcoes
mean(carros$preco)
median(carros$preco)
quantile(carros$preco)
quantile(carros$preco, probs = c(0.01, 0.99))
quantile(carros$preco, seq( from = 0, to = 1, by = 0.20))
IQR(carros$preco) #Diferença entre Q3 e Q1
range(carros$preco)
diff(range(carros$preco))

# Plot

# Boxplot
# Leitura de Baixo para Cima - Q1, Q2 (Mediana) e Q3
boxplot(carros$preco, main = "Boxplot para os Preços de Carros Usados", ylab = "Preço (R$)")
boxplot(carros$kilometragem, main = "Boxplot para a Km de Carros Usados", ylab = "Kilometragem (R$)")

# Histograma
# Indicam a frequencia de valores dentro de cada bin (classe de valores)
hist(carros$preco, main = "Histograma para os Preços Carros Usados", xlab = "Preço (R$)")
hist(carros$kilometragem, main = "Histograma para a Km de Carros Usados", ylab = "Kilometragem (R$)")
hist(carros$kilometragem, main = "Histograma para a Km de Carros Usados", breaks = 5, ylab = "Kilometragem (R$)")

# Scatterplot Preço x Km
# Usando o preco como variavel dependente (y)
plot(x = carros$kilometragem, y = carros$preco,
     main = "Scatterplot Preço x Km",
     xlab = "Kilometragem",
     ylab = "Preço (R$)")

# Medidas de Dispersao
# Ao interpretar a variancia, numeros maiores indicam que 
# os dados estao espalhados mais amplamente em torno da 
# media. O desvio padrao indica, em media, a quantidade 
# de cada valor diferente da media.
var(carros$preco)
sd(carros$preco)
var(carros$kilometragem)
sd(carros$kilometragem)


## Explorando variaveis categoricas

# Criando tabelas de contingencia - representam uma unica variavel categorica
# Lista as categorias das variaveis nominais
?table
str(carros)
table(carros$cor)
table(carros$modelo)
str(carros)

# Calculando a proporcao de cada categoria
model_table <- table(carros$modelo)
prop.table(model_table)

# Arrendondando os valores
model_table <- table(carros$modelo)
model_table <- prop.table(model_table) * 100
round(model_table, digits = 1)

# Criando uma nova variavel indicando cores conservadoras 
# (que as pessoas compram com mais frequencia)
head(carros)
carros$conserv <- carros$cor %in% c("Preto", "Cinza", "Prata", "Branco")
head(carros)

# Checando a variavel
table(carros$conserv)

# Verificando o relacionamento entre 2 variaveis categoricas
# Criando uma crosstable 
# Tabelas de contingencia fornecem uma maneira de exibir 
# as frequencias e frequencias relativas de observacoes 
# (lembra do capitulo de Estatistica?), que sao classificados 
# de acordo com duas variaveis categoricas. Os elementos de 
# uma categoria sao exibidas atraves das colunas; 
# os elementos de outra categoria sao exibidas sobre as linhas.
install.packages("gmodels")
library(gmodels)
?CrossTable
CrossTable(x = carros$modelo, y = carros$conserv)


## Teste do Qui-quadrado

# Qui Quadrado, simbolizado por χ2 eh um teste de 
# hipoteses que se destina a encontrar um valor da 
# dispersao para duas variaveis nominais, avaliando a 
# associacao existente entre variaveis qualitativas.

# Eh um teste nao parametrico, ou seja, nao depende dos 
# parametros populacionais, como media e variancia.

# O principio basico deste metodo eh comparar proporcoes, 
# isto eh, as possiveis divergencias entre as frequencias 
# observadas e esperadas para um certo evento.
# Evidentemente, pode-se dizer que dois grupos se 
# comportam de forma semelhante se as diferencas entre 
# as frequencias observadas e as esperadas em cada 
# categoria forem muito pequenas, proximas a zero.

# Ou seja, Se a probabilidade eh muito baixa, ele fornece 
# fortes evidencias de que as duas variaveis estao 
# associadas.

CrossTable(x = carros$modelo, y = carros$conserv, chisq = TRUE)
chisq.test(x = carros$modelo, y = carros$conserv)


# Trabalhamos com 2 hipoteses:
# Hipotese nula: As frequencias observadas nao sao diferentes das frequencias esperadas.
# Nao existe diferenca entre as frequencias (contagens) dos grupos.
# Portanto, nao ha associacao entre os grupos
# Hipotese alternativa: As frequencias observadas são diferentes da frequencias esperadas, 
# portanto existe diferenca entre as frequencias.
# Portanto, ha associacao entre os grupos.


# Neste caso, o valor do Chi = 0.15  
# E graus de liberdade (df) = 2
# Portanto, nao ha associacao entre os grupos
# O valor alto do p-value confirma esta conclusao.





