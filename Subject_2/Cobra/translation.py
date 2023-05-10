#!/usr/bin/env python3
#
# EPITECH PROJECT, 2023
# WelcomeDayPromo2028
# File description:
# translation.py
#

import sys


def lettre(c):
    car = ord(c.upper())
    return 64 < car < 91


def decalage(c, k):
    car = ord(c.upper())
    if lettre(c):
        car += k
        while car > 90:
            car -= 26
        while car < 65:
            car += 26
        return chr(car)
    else:
        return ""


def vigenere(message, cle, crypte):
    n = 0
    chiffre = ''
    for c in message:
        if lettre(c):
            k = ord(cle[n % len(cle)]) - 65
            if crypte:
                chiffre += decalage(c, k)
            else:
                chiffre += decalage(c, -k)
            n += 1
        else:
            chiffre += c
    return chiffre


def vigenere_main(argc, argv):
    if argc != 4 and (argv[1] != 'encode' or argv[1] != 'decode'):
        print("Usage: ./vigenere_code.py (encode or decode) key decoded")
        return 84
    try:
        open_file = open(argv[3], "r")
        content = open_file.read()
    except:
        print("Error: can't open decoded")
        return 84
    if argv[1] == 'encode':
        key = argv[2]
        ciphertext = vigenere(content, key, True)
        print(ciphertext)
    elif argv[1] == 'decode':
        key = argv[2]
        plaintext = vigenere(content, key, False)
        print(plaintext)


vigenere_main(len(sys.argv), sys.argv)
