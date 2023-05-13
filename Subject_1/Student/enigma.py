#!/usr/bin/env python3
#
# EPITECH PROJECT, 2023
# WelcomeDayPromo2028
# File description:
# enigma.py
#

import string

# Configuration des rotors et des réflecteurs
rotor_1 = "EKMFLGDQVZNTOWYHXUSPAIBRCJ"
rotor_2 = "AJDKSIRUXBLHWTMCQGZNPYFVOE"
rotor_3 = "BDFHJLCPRTXVZNYEIWGAKMUSQO"
reflector = "YRUHQSLDPXNGOKMIEBFZCWVJAT"

# Fonction enigma(machine, char)
#     Entrées : un dictionnaire machine et un caractère char
#     Sorties : un caractère
#     Si char est dans string.ascii_uppercase
#         # Passage à travers les rotors (de droite à gauche)
#         Pour chaque rotor dans rotors inversés
#             char = rotor[(index de char dans string.ascii_uppercase + position) modulo 26]
#         Fin Pour
#         # Passage à travers le réflecteur
#         char = reflector[index de char dans string.ascii_uppercase]
#
#         # Passage à travers les rotors (de gauche à droite)
#         Pour chaque rotor dans rotors
#             char = string.ascii_uppercase[(index de char dans rotor - position) modulo 26]
#         Fin Pour
#         # Incrémentation des positions des rotors
#         position = (position + 1) modulo 26
#     Fin Si
#     Retourner char
# Fin Fonction

# Configuration initiale de la machine Enigma
machine = {
    "rotors": [rotor_1, rotor_2, rotor_3],
    "position": 0
}

ciphertext = ""

print("Texte chiffré : ", ciphertext)

# Déchiffrement du texte chiffré
decrypted_text = ""

# Pour chaque char dans ciphertext
#     Si char est dans string.ascii_uppercase
#         decrypted_text += enigma(machine, char)
# Fin Pour

print("Texte déchiffré : ", decrypted_text)
