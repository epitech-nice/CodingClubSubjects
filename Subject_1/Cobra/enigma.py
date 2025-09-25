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

# Fonction de chiffrement/déchiffrement
def enigma(machine, char):
    if char in string.ascii_uppercase:
        # Passage à travers les rotors (de droite à gauche)
        for rotor in reversed(machine["rotors"]):
            char = rotor[(string.ascii_uppercase.index(char) + machine["position"]) % 26]

        # Passage à travers le réflecteur
        char = reflector[string.ascii_uppercase.index(char)]

        # Passage à travers les rotors (de gauche à droite)
        for rotor in machine["rotors"]:
            char = string.ascii_uppercase[(rotor.index(char) - machine["position"]) % 26]

        # Incrémentation des positions des rotors
        machine["position"] = (machine["position"] + 1) % 26

    return char

# Configuration initiale de la machine Enigma
machine = {
    "rotors": [rotor_1, rotor_2, rotor_3],
    "position": 0
}

# Chiffrement du mot "PathTek"
plaintext = "PATHTEK"
ciphertext = ""

for char in plaintext:
    if char in string.ascii_uppercase:
        ciphertext += enigma(machine, char)

print("Texte chiffré : ", ciphertext)

# Réinitialisation de la machine Enigma
machine["position"] = 0

# Déchiffrement du texte chiffré
decrypted_text = ""

for char in ciphertext:
    if char in string.ascii_uppercase:
        decrypted_text += enigma(machine, char)

print("Texte déchiffré : ", decrypted_text)
