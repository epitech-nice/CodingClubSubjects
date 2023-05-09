#!/usr/bin/env python3
#
# EPITECH PROJECT, 2023
# WelcomeDayPromo2028
# File description:
# bits.py
#

binary_string = "00010000 00000001 00010100 00001000 00010100 00000101 00001011"
binary_list = binary_string.split()  # Sépare les groupes de chiffres binaires

numbers = []
for binary in binary_list:
    number = int(binary, 2)  # Convertit chaque groupe de chiffres binaires en nombre décimal
    numbers.append(number)

print(numbers)

numbers = [16, 1, 20, 8, 20, 5, 11]

alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

letters = []
for number in numbers:
    letter = alphabet[number - 1]
    letters.append(letter)

word = ''.join(letters)
print(word)
