#!/usr/bin/env python3
#
# EPITECH PROJECT, 2023
# WelcomeDayPromo2028
# File description:
# my_cesar.py
#

import sys


def cesar(key, text):
    text = text.lower()
    key = key % 26
    new_text = ""
    for letter in text:
        if letter.isalpha():
            if letter.isupper():
                new_text += chr((ord(letter) + key - 65) % 26 + 65)
            else:
                new_text += chr((ord(letter) + key - 97) % 26 + 97)
        else:
            new_text += letter
    print(new_text)


def main(argc, argv):
    if argc != 3 :
        print("Usage: ./cesar.py key file")
        return 84
    try:
        open_file = open(argv[2], "r")
        content = open_file.read()
    except:
        print("Error: can't open file")
        return 84
    cesar(int(argv[1]), content)


main(len(sys.argv), sys.argv)
