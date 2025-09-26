##
## EPITECH PROJECT, 2023
## GrinchKong
## File description:
## events
##

import pygame

def game_exit(keys, inPlay, replay):
    if keys[pygame.K_ESCAPE]: #reset variables to quit program
        inPlay, replay = False, False
    return inPlay, replay
