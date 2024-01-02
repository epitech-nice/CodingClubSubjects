##
## EPITECH PROJECT, 2023
## GrinchKong
## File description:
## utils
##

import pygame

# Function to load a series of images with a common path and varying suffixes
def load_images(base_path, suffixes):
    return [pygame.image.load(f"{base_path}/{suffix}.png") for suffix in suffixes]


def display_sprite(screen, sprite, x, y):
    """
    grinch - outputs GRINCH onto screen
    @param: none
    @return: none
    """
    screen.blit(sprite, (x, y))
