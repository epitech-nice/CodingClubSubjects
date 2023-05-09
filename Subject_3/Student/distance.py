#!/usr/bin/env python3
#
# EPITECH PROJECT, 2023
# WelcomeDayPromo2028
# File description:
# distance.py
#

import math


def compute_lunar_flight_duration(distance):
    """Calcul la durée de vol nécessaire pour atteindre la Lune en fonction de la distance entre la Terre et la Lune."""
    # Distance Terre-Lune en km
    # d = ____
    # Vitesse moyenne de la fusée en km/h
    # v = ____
    # Durée de vol en heures
    # t = math.ceil(____ / ____)
    # Conversion en heures et minutes
    # hours = ____ // ____
    # minutes = ____ % ____
    # return f"{____} heures et {____} minutes"


def cesar_cipher(message, key):
    """Chiffre un message en utilisant le chiffrement César."""
    ciphertext = ""
    for letter in message:
        # Conversion en code ASCII
        ascii_code = ord(letter)
        # Application du décalage avec la clé de chiffrement
        shifted_code = (ascii_code - 65 + key) % 26 + 65
        # Conversion en caractère
        shifted_letter = chr(shifted_code)
        # Ajout au message chiffré
        ciphertext += shifted_letter
    return ciphertext


def cesar_decipher(ciphertext, key):
    """Déchiffre un message chiffré en utilisant le chiffrement César."""
    plaintext = ""
    for letter in ciphertext:
        # Conversion en code ASCII
        ascii_code = ord(letter)
        # Application du décalage avec la clé de chiffrement
        shifted_code = (ascii_code - 65 - key) % 26 + 65
        # Conversion en caractère
        shifted_letter = chr(shifted_code)
        # Ajout au message déchiffré
        plaintext += shifted_letter
    return plaintext


# Programme principal
distance = int(input("Distance Terre-Lune en km : "))
duration = compute_lunar_flight_duration(distance)
print(f"Durée de vol : {duration}")

message = input("Entrez un message à chiffrer : ")
key = int(input("Entrez une clé de chiffrement : "))
ciphertext = cesar_cipher(message, key)
print(f"Message chiffré : {ciphertext}")

plaintext = cesar_decipher(ciphertext, key)
print(f"Message déchiffré : {plaintext}")
