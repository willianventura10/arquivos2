soma=lambda a,b:(a+b)

subtracao=lambda a,b:(a-b)

multiplicacao=lambda a,b:(a*b)

divisao=lambda a,b:(a/b)

def main():
    print("\n************Python Calculator************\n")
    print("Selecione o número da operação desejada\n")
    print("1 - Soma\n2 - Subtração\n3 - Multiplicação\n4 - Divisão\n")
    x=0
    while x!=1 and x!=2 and x!=3 and x!=4:
        x = int(input("Digite sua opção (1/2/3/4): "))
    a = int(input("Digite o primeiro número: "))
    b = int(input("Digite o segundo número: "))

    if x == 1:
        print('\n',a,'+',b,'=',soma(a,b),'\n')
    
    elif x == 2:
        print('\n',a,'-',b,'=',subtracao(a,b),'\n')
    
    elif x == 3:
        print('\n',a,'*',b,'=',multiplicacao(a,b),'\n')

    elif x == 4:
        print('\n',a,'÷',b,'=',divisao(a,b),'\n')
    x=0
    while x!=1 and x!=2:
        x = int(input("Digite 1 para retornar ao início ou 2 para sair: "))
        if x==1:
            main()
        else:
            print("\nObrigado! e Até mais!")
            break
main()
