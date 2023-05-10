#!/usr/bin/env python3
#
# EPITECH PROJECT, 2023
# WelcomeDayPromo2028
# File description:
# translation.py
#

# import sys

# Fonction lettre(c)
#     Entrées : une lettre
#     Sorties : True / False
#     car = ASCII(c en majuscule)
#     Si car est compris entre 65 et 90 (inclus)
#         Retourner Vrai
#     Sinon
#         Retourner Faux
#     Fin Si
# Fin Fonction


# Fonction decalage(c, k)
#     Entrées : une lettre, un entier
#     Sorties : une lettre
#     car = ASCII(c en majuscule)
#     Si lettre(c) est Vrai
#         car += k
#         Tant que car > 90
#             car -= 26
#         Fin Tant que
#         Tant que car < 65
#             car += 26
#         Fin Tant que
#         Retourner caractère correspondant à car
#     Sinon
#         Retourner chaîne vide
#     Fin Si
# Fin Fonction


# Fonction vigenere(message, cle, crypte)
#     Entrées : une chaîne de caractères, une chaîne de caractères, un booléen
#     Sorties : une chaîne de caractères
#     n = 0
#     chiffre = ''
#     Pour chaque caractère c dans message
#         Si lettre(c) est Vrai
#             k = ASCII(cle[n % longueur(cle)]) - 65
#             Si crypte est Vrai
#                 chiffre += decalage(c, k)
#             Sinon
#                 chiffre += decalage(c, -k)
#             Fin Si
#                 n += 1
#             Sinon
#                 chiffre += c
#         Fin Si
#     Fin Pour
#     Retourner chiffre
# Fin Fonction


# Fonction vigenere_main(argc, argv)
#     Entrées : un entier, un tableau de chaînes de caractères
#     Sorties : un entier
#     Si argc n'est pas égal à 4 ou (argv[1] n'est pas 'encode' et argv[1] n'est pas 'decode')
#         Afficher "Usage: ./vigenere_code.py (encode or decode) key decoded"
#         Retourner 84
#     Fin Si
#     Essayer
#         open_file = ouvrir(argv[3], "r")
#         content = lire(open_file)
#     Sauf
#         Afficher "Error: can't open decoded"
#         Retourner 84
#     Fin Essayer
#     Si argv[1] est égal à 'encode'
#         key = argv[2]
#         ciphertext = vigenere(content, key, Vrai)
#         Afficher(ciphertext)
#     Sinon si argv[1] est égal à 'decode'
#         key = argv[2]
#         plaintext = vigenere(content, key, Faux)
#         Afficher(plaintext)
#     Fin Si
# Fin Fonction


# vigenere_main(len(sys.argv), sys.argv)
