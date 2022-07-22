#Definindo local de trabalho
setwd("D:/Data_Science/Cursos/DSA/Formacao_Cientista_de_Dados/Big_Data_Analytics_com_R_e_Microsoft_Azure_Machine_Learning/Modulo7/Projeto03")

#carregando bibliotecas
library(ggplot2)
library(ggthemes)
library(dplyr)
library(corrplot)
library(corrgram)
library(caTools)

#Carregando dataset
df <- read.csv("D:/Data_Science/Cursos/DSA/Formacao_Cientista_de_Dados/Big_Data_Analytics_com_R_e_Microsoft_Azure_Machine_Learning/Modulo7/Projeto03/despesas.csv")

#explorando dados
head(df)
summary(df)
str(df)
any(is.na(df))

#substituindo 'sim' e 'nao' por 2 e 1 respectivamente na coluna 'fumante'
df$fumante = recode_factor(df$fumante,"sim" = "2")
df$fumante = recode_factor(df$fumante,"nao" = "1")
df$fumante = as.numeric(df$fumante)

# Obtendo apenas as colunas numericas
colunas_numericas <- sapply(df, is.numeric)
colunas_numericas

# Filtrando as colunas numericas para correlacao
data_cor <- cor(df[,colunas_numericas])
data_cor
head(data_cor)

# Criando um corrplot
corrplot(data_cor,addCoef.col="black",number.cex=0.75)

# outras opções
pairs(df[c("idade", "bmi", "filhos","fumante", "gastos")])

library(psych)
# Este gráfico fornece mais informações sobre o relacionamento entre as variáveis
pairs.panels(df[c("idade", "bmi", "filhos","fumante", "gastos")])

# Criando um histograma
ggplot(df, aes(x = gastos)) + 
  geom_histogram(bins = 20, 
                 alpha = 0.5, fill = 'blue') + 
  theme_minimal()

# Criando as amostras de forma randomica
amostra <- sample.split(df$idade, SplitRatio = 0.70)

# Criando dados de treino - 70% dos dados
treino = subset(df, amostra == TRUE)

# Criando dados de teste - 30% dos dados
teste = subset(df, amostra == FALSE)

# Gerando o Modelo (Usando todos os atributos)
modelo_v1 <- lm(gastos ~ ., treino)
modelo_v2 <- lm(gastos ~ fumante + bmi + idade, treino)
modelo_v3 <- lm(gastos ~ fumante + bmi, treino)

# Interpretando o Modelo
summary(modelo_v1)
summary(modelo_v2)
summary(modelo_v3)

# Residuos
# Diferenca entre os valores observados de uma variavel e seus valores previstos
# Seus residuos devem se parecer com uma distribuicao normal, o que indica
# que a media entre os valores previstos e os valores observados eh proximo de 0 (o que eh bom)

# Coeficiente - Intercept - a (alfa)
# Valor de a na equacao de Regressao

# Coeficiente - G2 - b (beta)
# Neste caso, o valor de G2 representa o valor de b na equacao de Regressao

# Erro Padrao
# Medida de variabilidade na estimativa do coeficiente a (alfa). O ideal eh que este valor 
# seja menor que o valor do coeficiente, mas nem sempre isso ira ocorrer.

# Asteriscos 
# Os asteriscos representam os niveis de significancia de acordo com o p-value.
# Quanto mais estrelas, maior a siginificancia.
# Atencao --> Muitos astericos indicam que eh improvavel que nao exista relacionamento entre as variaveis.

# Valor t
# Define se coeficiente da variavel eh significativo ou nao para o modelo. 
# Ele eh usado para calcular o p-value e os niveis de significancia.

# p-value
# O p-value representa a probabilidade que a variavel nao seja relevante. 
# Deve ser o menor valor possivel. Se este valor for realmente pequeno, o R ira mostrar o valor como notacao cientifica

# Significancia
# São aquelas legendas proximas as suas variaveis
# Espaco em branco - ruim
# Pontos - razoavel
# Asteriscos - bom
# Muitos asteriscos - muito bom

# Residual Standar Error
# Este valor representa o desvio padrao dos residuos

# Degrees of Freedom
# É a diferenca entre o numero de observacoes na amostra de treinamento e o numero de variaveis no seu modelo

# R-squared
# Ajuda a avaliar o nivel de precisao do nosso modelo. Quanto maior, melhor, sendo 1 o valor ideal.

# F-statistics
# Eh o teste F do modelo. Esse teste obtem os parametros do nosso modelo e compara com um modelo que tenha menos parametros
# Em teoria, um modelo com mais parametros tem um desempenho melhor. Se o seu modelo com mais parametros NAO tiver perfomance
# melhor que um modelo com menos parametros, o valor do p-value sera bem alto. Se o modelo com mais parametros tem performance
# melhor que um modelo com menos parametros, o valor do p-value sera mais baixo.

# Lembre que correlacao nao implica causalidade


# Visualizando o Modelo e Fazendo Previsoes

# Obtendo os residuos
res <- residuals(modelo_v1)

# Convertendo o objeto para um dataframe
res <- as.data.frame(res)
head(res)

# Histograma dos residuos

ggplot(res, aes(res)) +  
  geom_histogram(bins = 20, 
                 alpha = 0.5, fill = 'blue') 

# Plot do Modelo

# Fazendo as predicoes
prevendo_gastos <- predict(modelo_v1, teste)
prevendo_gastos

# Visualizando os valores previstos e observados
resultados <- cbind(prevendo_gastos, teste$gastos) 
colnames(resultados) <- c('Previsto','Real')
resultados <- as.data.frame(resultados)
resultados
min(resultados)

# Tratando os valores negativos
trata_zero <- function(x){
  if  (x < 0){
    return(0)
  }else{
    return(x)
  }
}

# Aplicando a funcao para tratar valores negativos em nossa previsao
resultados$Previsto <- sapply(resultados$Previsto, trata_zero)
resultados$Previsto

# Calculando o erro medio
# Quao distantes seus valores previstos estao dos valores observados
# MSE
mse <- mean((resultados$Real - resultados$Previsto)^2)
print(mse)

# RMSE
rmse <- mse^0.5
rmse

# Calculando R Squared
SSE = sum((resultados$Previsto - resultados$Real)^2)
SST = sum( (mean(df$gastos) - resultados$Real)^2)

# R-Squared
# Ajuda a avaliar o nivel de precisao do nosso modelo. Quanto maior, melhor, sendo 1 o valor ideal.
R2 = 1 - (SSE/SST)
R2

#fazendo uma previsão aleatória
df2 = data.frame(idade = 25, sexo = "homem",bmi = 24,filhos=2,fumante=1,regiao="sudeste")
prevendo_gastos2 <- predict(modelo_v1, df2)
prevendo_gastos2


# Otimizando a Performance do Modelo

# Adicionando uma variável com o dobro do valor das idades

# Um das principais diferenças da modelagem de regressão para outras técnicas de Machine Learning é que a regressão 
# tipicamente deixa a seleção das características de especificação do modelo a cargo do analista. Consequentemente, 
# se nós temos informação suficiente sobre como a selecão das variáveis está relacionada ao resultado, nós podemos usar esta 
# informacão para especificar o modelo e assim melhorar a performance.

# Em regressão linear, o relacionamento entre a variável independente e a variavel dependente é considerado linear, 
# embora isso possa não ser sempre verdade. Por exemplo, o efeito da idade nos gastos médicos pode não ser constante 
# através de todas as idades. O tratamento médico pode ser desproporcionalmente maior entre a populacão mais velha.

# A regressão linear responde pela fórmula: y = A + Bx

# Entretanto, em algumas situações, podemos querer incluir uma relacão não linear, adicionado um termo de maior ordem ao modelo de regressão, 
# tratando o modelo como polinomial. Sendo assim, a fórmula será: y = A + B1x + B2xˆ2

# A diferença entre estas duas equações é que o item adicional B2 (coeficiente Beta), será estimado a partir do efeito de xˆ2 (x elevado ao quadrado), 
# capturando assim o impacto da idade em função da idade ao quadrado.

# Ao incluirmos idade e idade2 ao modelo, isso nos permitirá separar o impacto linear e não linear da idade nas despesas médicas. 
# ** A criacão da variável idade2 poderia levar ao questionamento sobre a multicolinearidade. Veja uma explicação abaixo sobre isso.

treino$idade2 <- (treino$idade)^2
teste$idade2 <- (teste$idade)^2

# Adicionando um indicador para BMI >= 30
treino$bmi30 <- ifelse(treino$bmi >= 30, 1, 0)
teste$bmi30 <- ifelse(teste$bmi >= 30, 1, 0)

# Criando o modelo final
modelo_v4 <- lm(gastos ~ idade + idade2 + filhos + bmi + sexo +
                  bmi30 * fumante + regiao, data = treino)

# Obtendo os residuos
res2 <- residuals(modelo_v4)

# Convertendo o objeto para um dataframe
res2 <- as.data.frame(res2)
head(res2)

# Histograma dos residuos

ggplot(res2, aes(res2)) +  
  geom_histogram(bins = 20, 
                 alpha = 0.5, fill = 'blue') 

# Fazendo as predicoes
prevendo_gastos <- predict(modelo_v4, teste)
prevendo_gastos

# Visualizando os valores previstos e observados
resultados2 <- cbind(prevendo_gastos, teste$gastos) 
colnames(resultados2) <- c('Previsto','Real')
resultados2 <- as.data.frame(resultados2)
resultados2
min(resultados2)

# Tratando os valores negativos
trata_zero <- function(x){
  if  (x < 0){
    return(0)
  }else{
    return(x)
  }
}

# Aplicando a funcao para tratar valores negativos em nossa previsao
resultados2$Previsto <- sapply(resultados2$Previsto, trata_zero)
resultados2$Previsto

# Calculando o erro medio
# Quao distantes seus valores previstos estao dos valores observados
# MSE
mse <- mean((resultados2$Real - resultados2$Previsto)^2)
print(mse)

# RMSE
rmse <- mse^0.5
rmse

# Calculando R Squared
SSE = sum((resultados2$Previsto - resultados2$Real)^2)
SST = sum( (mean(df$gastos) - resultados2$Real)^2)

# R-Squared
# Ajuda a avaliar o nivel de precisao do nosso modelo. Quanto maior, melhor, sendo 1 o valor ideal.
R2 = 1 - (SSE/SST)
R2

# Interpretando o Modelo
summary(modelo_v1)
summary(modelo_v4)


# ** Multicolinearidade

# A criação da variavel idade2 poderia levar ao questionamento sobre a multicolinearidade. Mas o que eh multicolinearidade?

# A multicolinearidade é um problema comum quando estimamos modelos de regressão linear, incluindo regressão logística. Este problema 
# ocorre quando existe alta correlação entre as variáveis preditivas, gerando estimativas não confiáveis dos coeficientes de regressão. 
# Com certeza este fenômeno é algo que requer atenção especial do Cientista de Dados, mas em alguns casos pode ser ignorada com segurança.

# Em nosso projeto, a multicolinearidade não é um problema. A multicolinearidade precisa ser verificada e resolvida quando queremos estimar o 
# efeito independente de duas variáveis que estão correlacionadas. Em nosso caso, não estamos interessados em avaliar o efeito da mudança 
# independente das variáveis idade e idade2. Sempre que se realiza um estudo que envolve idade é uma boa prática incluir a idade ao 
# quadrado para reduzir o efeito da idade no processo de modelagem, pois como vimos a relação da variável independente com a variável 
# idade (dependente) pode não ser necessariamente linear. A multicolinearidade estará presente, mas não afetará nosso objetivo final.
