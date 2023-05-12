#!/usr/bin/env python3
#
# EPITECH PROJECT, 2023
# WelcomeDayPromo2028
# File description:
# distance.py
#

import math

def compute_lunar_flight_duration(distance):
    """
        Calcul la durée de vol nécessaire pour atteindre la Lune
        en fonction de la distance entre la Terre et la Lune.
    """
    # Distance Terre-Lune en km
    # _ = _
    # Vitesse moyenne de la fusée en km/h
    # _ = _
    # Durée de vol en heures
    # _ = arrondi( _ / _)
    # Conversion en heures et minutes
    # days = _ _ _
    # hours = _ _ _
    # minutes = _ _ _ _ _
    # return f"{ _ } heures et { _ } minutes"

# Fonction cesar_cipher(message, key)
#     Entrées : une chaîne de caractères et un entier
#     Sortie : une chaîne de caractères
#     ciphertext = ""
#     Pour chaque lettre dans message
#         ascii_code = ASCII(lettre)
#         shifted_code = (ascii_code - _ + key) modulo _ + _
#         shifted_letter = caractère correspondant à shifted_code
#         ciphertext += shifted_letter
#     Fin Pour
#     Retourner ciphertext
# Fin Fonction

# Fonction cesar_decipher(ciphertext, key)
#     Entrées : une chaîne de caractères et un entier
#     Sortie : une chaîne de caractères
#     plaintext = ""
#     Pour chaque lettre dans ciphertext
#         ascii_code = ASCII(lettre)
#         shifted_code = (ascii_code - _ - key) modulo _ + _
#         shifted_letter = caractère correspondant à shifted_code
#         plaintext += shifted_letter
#     Fin Pour
#     Retourner plaintext
# Fin Fonction

# Programme principal
distance = int(input("Distance Terre-Lune en km : "))
duration = 0
print(f"Durée de vol : {duration}")

message = input("Entrez un message à déchiffrer : ")
key = int(input("Entrez une clé de chiffrement : "))

plaintext = ""
print(f"Message déchiffré : {plaintext}")
