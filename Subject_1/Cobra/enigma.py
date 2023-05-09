#!/usr/bin/env python3
#
# EPITECH PROJECT, 2023
# WelcomeDayPromo2028
# File description:
# enigma.py
#

import string
import random

class Enigma:
    def __init__(self, rotors, rotor_positions):
        self.rotors = rotors
        self.rotor_positions = rotor_positions

    def set_rotor_positions(self, positions):
        self.rotor_positions = positions

    def encode(self, letter):
        # Tourner les rotors
        self.rotate()

        # Convertir la lettre en un entier de 0 à 25
        letter_index = ord(letter.upper()) - 65

        # Passer la lettre à travers les rotors dans l'ordre
        for rotor in self.rotors:
            letter_index = rotor[letter_index]

        # Passer la lettre à travers le réflecteur
        letter_index = (letter_index + 13) % 26

        # Passer la lettre à travers les rotors dans l'ordre inverse
        for rotor in reversed(self.rotors):
            letter_index = rotor.index(letter_index)

        # Convertir l'entier de 0 à 25 en une lettre
        return chr(letter_index + 65)

    def rotate(self):
        # Tourner le rotor droit
        self.rotor_positions[2] = (self.rotor_positions[2] + 1) % 26

        # Si le rotor droit est à la position de rotation de la notch, tourner le rotor du milieu
        if self.rotor_positions[2] == self.rotors[2].index(self.rotors[2].notch):
            self.rotor_positions[1] = (self.rotor_positions[1] + 1) % 26

        # Si le rotor du milieu est à la position de rotation de la notch, tourner le rotor de gauche
        if self.rotor_positions[1] == self.rotors[1].index(self.rotors[1].notch):
            self.rotor_positions[0] = (self.rotor_positions[0] + 1) % 26

    def set_rotor_positions(self, positions):
        self.rotor_positions = positions


# Configuration de rotors et de réglages
enigma = Enigma(['EKMFLGDQVZNTOWYHXUSPAIBRCJ', 'AJDKSIRUXBLHWTMCQGZNPYFVOE', 'BDFHJLCPRTXVZNYEIWGAKMUSQ'], [0, 0, 0])

# Texte à chiffrer
plaintext = 'PathTek'

# Chiffrement du texte
ciphertext = ''
for i in range(len(plaintext)):
    enigma.set_rotor_positions([i, i, i])
    ciphertext += enigma.encode(plaintext[i])
print(ciphertext) # imprime "GZTLFAJ"

# Déchiffrement du texte
enigma = Enigma(['EKMFLGDQVZNTOWYHXUSPAIBRCJ', 'AJDKSIRUXBLHWTMCQGZNPYFVOE', 'BDFHJLCPRTXVZNYEIWGAKMUSQ'], [0, 0, 0]) # Réinitialiser la machine avec les mêmes paramètres
plaintext = ''
for i in range(len(ciphertext)):
    enigma.set_rotor_positions([i, i, i])
    plaintext += enigma.encode(ciphertext[i])
print(plaintext) # imprime "PATHTek"
