# Exercicios Capitulo 3

# Exercicio 1 - Crie uma funcao que receba e vetores como parametro, converta-os em um dataframe e imprima

vetores <- function(veto){
  df <- data.frame(veto)
  print(df)
}

vetor = c(1,2,3)
vetores(vetor)


# Exercicio 2 - Crie uma matriz com 4 linhas e 4 colunas preenchida com numeros inteiros e calcule a media de cada linha

mat <- matrix(c(1:16), nrow = 4, ncol = 4)
mat
apply(mat, 1, mean)

# Exercicio 3 - Considere o dataframe abaixo. Calcule a media por disciplina
escola <- data.frame(Aluno = c('Alan', 'Alice', 'Alana', 'Aline', 'Alex', 'Ajay'),
                     Matematica = c(90, 80, 85, 87, 56, 79),
                     Geografia = c(100, 78, 86, 90, 98, 67),
                     Quimica = c(76, 56, 89, 90, 100, 87))

sprintf("A média de matemática é %s", mean(escola$Matematica))
sprintf("A média de geografia é %s", mean(escola$Geografia))
sprintf("A média de quimica é %s", mean(escola$Quimica))

apply(escola[, c(2:4)], 2, mean)


# Exercicio 4 - Cria uma lista com 3 elementos, todos numéricos e calcule a soma de todos os elementos da lista

lista <- list(1,2,3)
s = 0
for (i in lista){
  s = s+i
}

do.call(sum,lista)

sprintf("A soma é %s", s)
sprintf("A soma é %s", do.call(sum,lista))

# Exercicio 5 - Transforme a lista anterior um vetor

vetlis <- unlist(lista)
class(vetlis)
sum(vetlis)

# Exercicio 6 - Considere a string abaixo. Substitua a palavra textos por frases
library(stringr)
str <- c("Expressoes", "regulares", "em linguagem R", 
         "permitem a busca de padroes", "e exploracao de textos",
         "podemos buscar padroes em digitos",
         "como por exemplo",
         "10992451280")

str2 = str_replace_all(str,"texto","frases")
str2

# Exercicio 7 - Usando o dataset mtcars, crie um grafico com ggplot do tipo scatter plot. Use as colunas disp e mpg nos eixos x e y respectivamente
library(ggplot2)

ggplot(mtcars, aes(x=disp, y=mpg)) + geom_point() +  geom_smooth(method = lm , color = "darkblue", se = FALSE) + geom_smooth(method=lm)

# Exercicio 8 - Usando o exemplo anterior, explore outros tipos de gráficos

ggplot(mtcars, aes(x=cyl, y=mpg)) + 
  geom_bar(stat = "identity")


