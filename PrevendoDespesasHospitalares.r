# Prevendo Despesas Hospitalares

# Para esta análise, vamos usar um conjunto de dados simulando despesas médicas hipotéticas 
# para um conjunto de pacientes espalhados por 4 regiões do Brasil.
# Esse dataset possui 1.338 observações e 7 variáveis.

# Etapa 1 - Coletando os dados
despesas <- read.csv("despesas.csv")


# Etapa 2: Explorando e Preparando os Dados
# Visualizando as variáveis
str(despesas)

# Medias de Tendência Central da variável gastos
summary(despesas$gastos)

# Construindo um histograma
hist(despesas$gastos, main = 'Histograma', xlab = 'Gastos')

# Tabela de contingência das regiões
table(despesas$regiao)

# Explorando relacionamento entre as variáveis: Matriz de Correlação
cor(despesas[c("idade", "bmi", "filhos", "gastos")])

# Nenhuma das correlações na matriz são consideradas fortes, mas existem algumas associações interessantes. 
# Por exemplo, a idade e o bmi (IMC) parecem ter uma correlação positiva fraca, o que significa que 
# com o aumento da idade, a massa corporal tende a aumentar. Há também uma correlação positiva 
# moderada entre a idade e os gastos, além do número de filhos e os gasos. Estas associações implicam 
# que, à media que idade, massa corporal e número de filhos aumenta, o custo esperado do seguro saúde sobe. 

# Visualizando relacionamento entre as variáveis: Scatterplot
# Perceba que não existe um claro relacionamento entre as variáveis
pairs(despesas[c("idade", "bmi", "filhos", "gastos")])

# Scatterplot Matrix
# install.packages("psych")
library(psych)
# Este gráfico fornece mais informações sobre o relacionamento entre as variáveis
pairs.panels(despesas[c("idade", "bmi", "filhos", "gastos")])

# Etapa 3: Treinando o Modelo
modelo <- lm(gastos ~ idade + filhos + bmi + sexo + fumantes + regiao,
                data = despesas)

# Similar ao item anterior
modelo <- lm(gastos ~ ., data = despesas)

# Visualizando os coeficientes
modelo

# Prevendo despesas médicas 
previsao <- predict(modelo)
class(previsao)
head(previsao)


# Etapa 4: Avaliando a Performance do Modelo
# Mais detalhes sobre o modelo
summary(modelo)


# Etapa 5: Otimizando a Performance do Modelo

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

despesas$idade2 <- despesas$idade ^ 2

# Adicionando um indicador para BMI >= 30
despesas$bmi30 <- ifelse(despesas$bmi >= 30, 1, 0)

# Criando o modelo final
modelo_v2 <- lm(gastos ~ idade + idade2 + filhos + bmi + sexo +
                   bmi30 * fumantes + regiao, data = despesas)

summary(modelo_v2)




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


