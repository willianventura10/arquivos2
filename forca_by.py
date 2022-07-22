# -*- coding: utf-8 -*-
"""
Created on Mon Nov  1 09:01:33 2021

@author: w3110
"""
import random
board = ['''
>>>>>>>>>>Forca!!<<<<<<<<<<

+---+
|   |
    |
    |
    |
    |
=========''', '''

+---+
|   |
O   |
    |
    |
    |
=========''', '''

+---+
|   |
O   |
|   |
    |
    |
=========''', '''

 +---+
 |   |
 O   |
/|   |
     |
     |
=========''', '''

 +---+
 |   |
 O   |
/|\  |
     |
     |
=========''', '''

 +---+
 |   |
 O   |
/|\  |
/    |
     |
=========''', '''

 +---+
 |   |
 O   |
/|\  |
/ \  |
     |
=========''']

class Forca():
    def rand_word(self):
        with open("D:\Python\Python\Cap05\Lab03\palavras.txt", "rt") as f:
            bank = f.readlines()
        return (bank[random.randint(0,len(bank))].strip())

    def mostrar(self,i,board):
        print(board[i])

def hide(letra,palavra,aux):
        print('\nPalavra:',end="")
        cont = 0
        for i1 in palavra:
            if i1 == letra:
                aux[cont]=letra
            cont+=1            
        for i2 in aux:
            print('',i2,end="")
            
def ganhou(aux):
        if '_' in aux:
            return (False)
        else:
            print ('\n\nParabéns! Você venceu!!')
            return (True)
            

def main():
    aux=[]
    corretas = []
    erradas = []
    palavra1 = Forca()
    palavra = palavra1.rand_word()
    terminou = False
    i=0
    chance=0
    palavra1.mostrar(i,board)
    print('\nPalavra:',end="")
    for i3 in palavra:
        aux.append('_')
        print('','_',end="")
    print('\n\nLetras Corretas:','\n\nLetras Erradas:',end="")
    print('\n\n',palavra)
    while terminou == False:
        if ganhou(aux) == True:
            break
        if chance == 6:
            print ('\n\nGame over! Você perdeu.')
            print ('A palavra era ' + palavra.upper()+'!')
            break
        letra=input('\nDigite uma letra ')
        while letra in corretas or letra in erradas:
            letra=input('\nDigite uma letra ')   
        if letra in palavra:
            corretas.append(letra)
        else:
            erradas.append(letra)
            chance+=1
            i+=1
        palavra1.mostrar(i,board)
        hide(letra,palavra,aux)
        print('\n\nLetras Corretas: ',end="")
        for i4 in corretas:
            print(i4,end=" ")
        print('\n\nLetras Erradas: ',end="")
        for i4 in erradas:
            print(i4,end=" ")
    
main()